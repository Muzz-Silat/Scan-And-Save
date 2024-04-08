Scan & Save

How to setup project
1. Clone the project repository: 

git clone https://git.cs.bham.ac.uk/projects-2023-24/mxs1576.git

2.  cd into mxs1576 if not already there

cd mxs1576

3. Open up a terminal and run the virtual environment
            
cd invoice_detector

python -m venv venv

venv\Scripts\activate

3. Install Requirements

     pip install -r requirements.txt

4. Run Flask API

     python app.py

5. Open up a new terminal and download dependencies for Flutter
      cd mxs1576
      flutter pub get
6. Get the URL from Flask API terminal
	Something like this http://192.168.0.125:5000/
7. Save it to the config.json file
{
  "apiBaseUrl": "http://<your-ip-address>:5000"
}

6. Run Flutter on and Android Emulator or Android Device:

       flutter run

A full tutorial for setting up an emulator can be found at https://developer.android. com/studio/run/emulator.
