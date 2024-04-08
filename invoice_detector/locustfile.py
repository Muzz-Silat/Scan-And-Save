from locust import HttpUser, task, between
import os

class APITestUser(HttpUser):
    wait_time = between(1, 5)  # Random wait time between tasks

    @task
    def predict_expense(self):
        payload = {
            "expenses": [100, 150, 200, 250, 300, 0, 0, 350, 400, 450, 500, 550, 600, 650, 700, 0, 750, 800, 850, 900, 950, 0, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350]
        }
        headers = {'Content-Type': 'application/json'}
        self.client.post("/predict", json=payload, headers=headers)

    @task
    def detect_invoice(self):
        image_path = 'temp_image.jpg'  # Ensure this path is correct
        
        # Make sure the file exists before attempting to open it
        if not os.path.exists(image_path):
            print(f"File {image_path} not found")
            return
        with open(image_path, 'rb') as image_file:
            # Construct the multipart request with the file
            files = {'image': (image_path, image_file, 'image/jpeg')}
            # Send the POST request
            response = self.client.post("/yolo/detect", files=files)