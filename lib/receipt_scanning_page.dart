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

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'expense.dart'; // Ensure this points to your Expense model
// import 'firestore_service.dart'; // Adjust this path to your FirestoreService
// import 'package:firebase_storage/firebase_storage.dart';

// class InvoiceDetectionPage extends StatefulWidget {
//   @override
//   _InvoiceDetectionPageState createState() => _InvoiceDetectionPageState();
// }

// class _InvoiceDetectionPageState extends State<InvoiceDetectionPage> {
//   List<String> categories = [
//     'Groceries',
//     'Dining Out',
//     'Transport',
//     'Entertainment',
//     'Travel',
//     'Education',
//     'Clothing & Accessories',
//     'Miscellaneous'
//   ];

//   XFile? _image;
//   final ImagePicker _picker = ImagePicker();
//   Map<String, dynamic>? _detectionResults;
//   List<TextEditingController> nameControllers = [];
//   List<TextEditingController> priceControllers = [];
//   List<String> selectedCategories = [];
//   final FirestoreService _firestoreService =
//       FirestoreService(); // Initialize your Firestore service
//   bool _isLoading = false; // Added loading state

//   Future pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = pickedFile;
//     });
//   }

//   Future submitImage() async {
//     if (_image == null) return;

//     setState(() {
//       _isLoading = true; // Indicate loading state
//     });

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse("http://192.168.0.125:5000/yolo/detect"),
//     );
//     request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

//     try {
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         setState(() {
//           _detectionResults = json.decode(response.body);
//           _displayOCRResults(); // Call to display OCR results after successful detection
//           _isLoading = false; // Loading completed
//         });
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to detect invoice. Please try again.'),
//           ),
//         );
//         setState(() {
//           _isLoading = false; // Reset loading state on error
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false; // Reset loading state on exception
//       });
//       print(e.toString());
//     }
//   }

//   void _displayOCRResults() {
//     final ocrResults = _detectionResults?['ocr_results'];
//     if (ocrResults == null) {
//       print('OCR results are not available.');
//       return;
//     }

//     final productNames = List<String>.from(ocrResults['Product Names'] ?? []);
//     final productPrices = List<double>.from(ocrResults['Product Prices'] ?? []);
//     final total = ocrResults['Total']?.toString() ?? '0.0'; // Initial total
//     final totalController =
//         TextEditingController(text: total); // Controller for editing the total

//     // Initialize controllers with OCR results
//     nameControllers =
//         productNames.map((name) => TextEditingController(text: name)).toList();
//     priceControllers = productPrices
//         .map((price) => TextEditingController(text: price.toString()))
//         .toList();
//     // After initializing nameControllers and priceControllers
//     selectedCategories =
//         List<String>.generate(productNames.length, (_) => categories.first);

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               ListView.builder(
//                 itemCount: nameControllers.length,
//                 shrinkWrap: true, // Allow ListView inside Column/ScrollView
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: TextFormField(
//                       controller: nameControllers[index],
//                       decoration: InputDecoration(labelText: 'Product Name'),
//                     ),
//                     subtitle: DropdownButton<String>(
//                       value: selectedCategories[index],
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedCategories[index] = newValue!;
//                         });
//                       },
//                       items: categories
//                           .map<DropdownMenuItem<String>>((String category) {
//                         return DropdownMenuItem<String>(
//                           value: category,
//                           child: Text(category),
//                         );
//                       }).toList(),
//                     ),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: TextFormField(
//                         controller: priceControllers[index],
//                         decoration: InputDecoration(labelText: 'Price'),
//                         keyboardType:
//                             TextInputType.numberWithOptions(decimal: true),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: totalController,
//                   decoration: InputDecoration(labelText: 'Total'),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close the bottom sheet
//                     _submitExpenses(nameControllers, priceControllers,
//                         totalController.text);
//                   },
//                   child: Text('Submit Expenses'),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _submitExpenses(List<TextEditingController> nameCtrls,
//       List<TextEditingController> priceCtrls, String editedTotal) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     try {
//       String? receiptUrl;
//       if (_image != null) {
//         // Upload the receipt image
//         String filePath =
//             'receipts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.png';
//         final ref = FirebaseStorage.instance.ref().child(filePath);
//         await ref.putFile(File(_image!.path));
//         receiptUrl = await ref.getDownloadURL();
//       }

//       // If we have a URL for the uploaded receipt, add it to the user's receipts
//       if (receiptUrl != null) {
//         var profileRef = FirebaseFirestore.instance
//             .collection('Users')
//             .doc(user.uid)
//             .collection('Profile')
//             .doc('personal');

//         // Use a transaction to ensure atomic updates
//         await FirebaseFirestore.instance.runTransaction((transaction) async {
//           DocumentSnapshot snapshot = await transaction.get(profileRef);

//           // Cast snapshot data to Map<String, dynamic> and handle potential nulls
//           Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
//           List<dynamic> receipts = [];
//           if (data != null && data.containsKey('receipts')) {
//             receipts = List.from(data['receipts']);
//           }

//           receipts.add(receiptUrl);
//           transaction.set(
//               profileRef, {'receipts': receipts}, SetOptions(merge: true));
//         });
//       }

//       // Add each detected expense to Firestore
//       for (int i = 0; i < nameCtrls.length; i++) {
//         final expense = Expense(
//           amount: double.tryParse(priceCtrls[i].text) ?? 0,
//           description: nameCtrls[i].text,
//           date: DateTime.now(),
//           currency: 'USD',
//           category: selectedCategories[i],
//         );
//         _firestoreService.addExpense(user.uid, expense.toMap());
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Expenses and receipt added successfully')));
//     } catch (e) {
//       print("Error handling expenses or uploading receipt: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error adding expenses or receipt')));
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
//               onPressed:
//                   !_isLoading ? submitImage : null, // Prevent double submit
//               child: _isLoading
//                   ? CircularProgressIndicator(backgroundColor: Colors.white)
//                   : Text('Submit Image'),
//             ),
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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:demo_flutter/config.dart';

class InvoiceDetectionPage extends StatefulWidget {
  @override
  _InvoiceDetectionPageState createState() => _InvoiceDetectionPageState();
}

class _InvoiceDetectionPageState extends State<InvoiceDetectionPage> {
  List<String> categories = [
    'Auto',
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
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  List<String> currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AED'
  ]; // Example currencies
  List<String> selectedCurrencies =
      []; // To store selected currency for each expense

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> submitImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConfig.apiBaseUrl}/yolo/detect'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final ocrResults = json.decode(response.body);
        setState(() {
          _detectionResults = ocrResults;
          _setupDetectedExpenses(ocrResults['ocr_results']);
          _isLoading = false;
        });
      } else {
        print(response.statusCode);
        _showErrorDialog();
      }
    } catch (e) {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to detect invoice. Please try again.'),
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _setupDetectedExpenses(Map<String, dynamic> ocrResults) {
    final productNames = List<String>.from(ocrResults['Product Names'] ?? []);
    final productPrices = List<double>.from(ocrResults['Product Prices'] ?? []);

    nameControllers =
        productNames.map((name) => TextEditingController(text: name)).toList();
    priceControllers = productPrices
        .map((price) => TextEditingController(text: price.toStringAsFixed(2)))
        .toList();
    selectedCategories =
        List<String>.generate(productNames.length, (_) => categories.first);
    selectedCurrencies =
        List<String>.filled(nameControllers.length, currencies.first);
  }

  Widget _buildExpenseForm(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameControllers[index],
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategories[index],
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategories[index] = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: priceControllers[index],
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            DropdownButtonFormField<String>(
              value: selectedCurrencies[index],
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCurrencies[index] = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Currency'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> categorizeExpenseWithChatGPT(String description) async {
    // Initialize your ChatGPT client
    final _openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: Duration(seconds: 5)),
      enableLog: true,
    );

    // Construct your prompt for ChatGPT
    final prompt = "Categorize the following expense: $description. "
        "Categories: Groceries, Dining Out, Transport, Entertainment, Travel, Education, Clothing & Accessories, Miscellaneous."
        "Ensure the output is only one of the Categories";

    // Send the prompt to ChatGPT and wait for the response
    final response = await _openAI.onChatCompletion(
        request: ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [Messages(role: Role.user, content: prompt)],
      maxToken: 200,
    ));

    // Parse the response from ChatGPT to match one of your categories
    String categorizedResponse =
        response!.choices.first.message!.content.trim();

    return categorizedResponse.replaceAll(".", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Receipt Scanning',
          style: TextStyle(fontFamily: "CourierPrime"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_image == null) ...[
              // ElevatedButton(
              //   onPressed: _isLoading ? null : pickImage,
              //   child: Text('Scan Receipt'),
              // )
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : pickImage,
                  child: Text(
                    'Scan Receipt',
                    style: TextStyle(
                      fontFamily: 'CourierPrime',
                      fontSize: 18,
                      color: Colors.black, // Black text color
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 103, 240, 173),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // More rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16), // Larger button
                  ),
                ),
              ),
            ] else
              Image.file(File(_image!.path)),
            if (_image != null && !_isLoading) ...[
              SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: submitImage,
                  child: Text(
                    'Submit Image',
                    style: TextStyle(
                      fontFamily: 'CourierPrime',
                      fontSize: 18,
                      color: Colors.black, // Black text color
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 103, 240, 173),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // More rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16), // Larger button
                  ),
                ),
              ),
            ],
            if (_isLoading) CircularProgressIndicator(),
            if (_detectionResults != null) ...[
              SizedBox(height: 15),
              for (int i = 0; i < nameControllers.length; i++)
                _buildExpenseForm(i),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () =>
                        _submitExpenses(nameControllers, priceControllers, ''),
                child: _isLoading
                    ? CircularProgressIndicator(backgroundColor: Colors.white)
                    : Text(
                        'Save Expenses',
                        style: TextStyle(
                          fontFamily: 'CourierPrime',
                          fontSize: 18,
                          color: Colors.black, // Black text color
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 103, 240, 173),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // More rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16), // Larger button
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _submitExpenses(List<TextEditingController> nameCtrls,
      List<TextEditingController> priceCtrls, String editedTotal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? receiptUrl;
      if (_image != null) {
        String filePath =
            'receipts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.png';
        final ref = FirebaseStorage.instance.ref().child(filePath);
        await ref.putFile(File(_image!.path));
        receiptUrl = await ref.getDownloadURL();
      }

      if (receiptUrl != null) {
        var profileRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Profile')
            .doc('personal');

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(profileRef);

          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          List<dynamic> receipts = [];
          if (data != null && data.containsKey('receipts')) {
            receipts = List.from(data['receipts']);
          }
          receipts.add(receiptUrl);
          transaction.set(
              profileRef, {'receipts': receipts}, SetOptions(merge: true));
        });
      }

      for (int i = 0; i < nameCtrls.length; i++) {
        String category = selectedCategories[i];
        if (category == 'Auto') {
          category = await categorizeExpenseWithChatGPT(nameCtrls[i].text);
        }
        final expense = Expense(
          amount: double.tryParse(priceCtrls[i].text) ?? 0,
          description: nameCtrls[i].text,
          date: DateTime.now(),
          currency: selectedCurrencies[i],
          category: category,
        );
        _firestoreService.addExpense(user.uid, expense.toMap());
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expenses and receipt added successfully')));
    } catch (e) {
      print("Error handling expenses or uploading receipt: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding expenses or receipt')));
    }
  }
}
