// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class InvoiceDetectionPage extends StatefulWidget {
//   @override
//   _InvoiceDetectionPageState createState() => _InvoiceDetectionPageState();
// }

// class _InvoiceDetectionPageState extends State<InvoiceDetectionPage> {
//   XFile? _image;
//   final ImagePicker _picker = ImagePicker();
//   Map<String, dynamic>? _detectionResults;

//   Future pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = pickedFile;
//     });
//   }

//   Future submitImage() async {
//     if (_image == null) return;

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse("http://192.168.0.125:5000/yolo/detect"),
//     );
//     request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200) {
//       setState(() {
//         _detectionResults = json.decode(response.body);
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to detect invoice. Please try again.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Invoice Detection'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (_image != null) Image.file(File(_image!.path)),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: Text('Pick Image'),
//             ),
//             ElevatedButton(
//               onPressed: submitImage,
//               child: Text('Submit Image'),
//             ),
//             if (_detectionResults != null) ...[
//               Text('Detection Results:'),
//               Text(json.encode(_detectionResults!['detections'] ?? {})),
//               if (_detectionResults?.containsKey('ocr_results') ?? false) ...[
//                 Text('OCR Results:'),
//                 // Example display, adjust based on your actual OCR results structure
//                 Text(json.encode(_detectionResults!['ocr_results'] ?? {})),
//               ],
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'expense.dart'; // Ensure this points to your Expense model
import 'firestore_service.dart'; // Adjust this path to your FirestoreService

class InvoiceDetectionPage extends StatefulWidget {
  @override
  _InvoiceDetectionPageState createState() => _InvoiceDetectionPageState();
}

class _InvoiceDetectionPageState extends State<InvoiceDetectionPage> {
  List<String> categories = [
    'Groceries',
    'Dining Out',
    'Transport',
    'Entertainment',
    'Travel',
    'Education',
    'Clothing & Accessories',
    'Miscellaneous'
  ];

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _detectionResults;
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> priceControllers = [];
  List<String> selectedCategories = [];
  final FirestoreService _firestoreService =
      FirestoreService(); // Initialize your Firestore service
  bool _isLoading = false; // Added loading state

  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future submitImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true; // Indicate loading state
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.0.125:5000/yolo/detect"),
    );
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _detectionResults = json.decode(response.body);
          _displayOCRResults(); // Call to display OCR results after successful detection
          _isLoading = false; // Loading completed
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to detect invoice. Please try again.'),
          ),
        );
        setState(() {
          _isLoading = false; // Reset loading state on error
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Reset loading state on exception
      });
      print(e.toString());
    }
  }

  void _displayOCRResults() {
    final ocrResults = _detectionResults?['ocr_results'];
    if (ocrResults == null) {
      print('OCR results are not available.');
      return;
    }

    final productNames = List<String>.from(ocrResults['Product Names'] ?? []);
    final productPrices = List<double>.from(ocrResults['Product Prices'] ?? []);
    final total = ocrResults['Total']?.toString() ?? '0.0'; // Initial total
    final totalController =
        TextEditingController(text: total); // Controller for editing the total

    // Initialize controllers with OCR results
    nameControllers =
        productNames.map((name) => TextEditingController(text: name)).toList();
    priceControllers = productPrices
        .map((price) => TextEditingController(text: price.toString()))
        .toList();
    // After initializing nameControllers and priceControllers
    selectedCategories =
        List<String>.generate(productNames.length, (_) => categories.first);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemCount: nameControllers.length,
                shrinkWrap: true, // Allow ListView inside Column/ScrollView
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextFormField(
                      controller: nameControllers[index],
                      decoration: InputDecoration(labelText: 'Product Name'),
                    ),
                    subtitle: DropdownButton<String>(
                      value: selectedCategories[index],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategories[index] = newValue!;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: priceControllers[index],
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: totalController,
                  decoration: InputDecoration(labelText: 'Total'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    _submitExpenses(nameControllers, priceControllers,
                        totalController.text);
                  },
                  child: Text('Submit Expenses'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitExpenses(List<TextEditingController> nameCtrls,
      List<TextEditingController> priceCtrls, String editedTotal) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    for (int i = 0; i < nameCtrls.length; i++) {
      final expense = Expense(
        amount: double.tryParse(priceCtrls[i].text) ?? 0,
        description: nameCtrls[i].text,
        date: DateTime.now(), // Adjust as necessary
        currency: 'USD', // This could be dynamic
        category: selectedCategories[i], // Consider user selection
      );
      // Assuming FirestoreService.addExpense correctly adds the expense
      _firestoreService.addExpense(user.uid, expense.toMap());
    }

    // Optionally handle the edited total separately if needed

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expenses added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Detection'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_image != null) Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed:
                  !_isLoading ? submitImage : null, // Prevent double submit
              child: _isLoading
                  ? CircularProgressIndicator(backgroundColor: Colors.white)
                  : Text('Submit Image'),
            ),
          ],
        ),
      ),
    );
  }
}
