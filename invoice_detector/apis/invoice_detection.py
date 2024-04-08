from flask_restx import Namespace, Resource
from flask import Flask, request, jsonify, make_response
import apis.config
import requests
import json
import time
from PIL import Image, ImageDraw

api = Namespace('yolo', description='Extraction data from Invoice(Implementation 1)')
def detect(image_path, url=apis.config.theos_url, conf_thres=0.25, iou_thres=0.45, ocr_model=None, ocr_classes=None, ocr_language=None, retries=10, delay=0):
    response = requests.post(url, data={'conf_thres':conf_thres, 'iou_thres':iou_thres, **({'ocr_model':ocr_model, 'ocr_classes':ocr_classes, 'ocr_language':ocr_language} if ocr_model is not None else {})}, files={'image':open(image_path, 'rb')})
    if response.status_code in [200, 500]:
        data = response.json()
        print(response)
        if 'error' in data:
            return {'error': data['message']}
        else:
            return data
    elif response.status_code == 403:
        return {'error': 'you reached your monthly requests limit. Upgrade your plan to unlock unlimited requests.'}
    elif retries > 0:
        if delay > 0:
            time.sleep(delay)
        return detect(image_path, url=apis.config.theos_url if apis.config.theos_url else apis.config.theos_url, retries=retries-1, delay=2)
    return []

def draw_boxes(image_path, detections):
    image = Image.open(image_path)
    
    # Convert image to RGB mode if it's in 'P' mode (palette mode)
    if image.mode == 'P':
        image = image.convert('RGB')

    draw = ImageDraw.Draw(image)
    for detection in detections:
        # Extracting detection parameters
        class_name = detection['class']
        confidence = detection['confidence']
        x, y = detection['x'], detection['y']
        width, height = detection['width'], detection['height']

        # Drawing the box
        draw.rectangle([x, y, x + width, y + height], outline=detection.get('color', 'white'), width=2)

        # Adding label
        label = f"{class_name} ({confidence:.2f})"
        draw.text((x, y - 20), label, fill=detection.get('color', 'white'))

    return image


@api.route('/detect')
class Detector(Resource):
    def post(self):
        if 'image' not in request.files:
            return jsonify({'error': 'No image provided'}), 400

        image_file = request.files['image']
        if image_file.filename == '':
            return jsonify({'error': 'No selected file'}), 400

        image_path = 'temp_image.jpg'  # Save the image temporarily
        image_file.save(image_path)

        # Perform object detection
        detections = detect(image_path)

        if 'error' in detections:
            return jsonify(detections), 400

        # Call the OCR analysis endpoint
        ocr_response = requests.post('http://127.0.0.1:5000/easyOCR/analyze_invoice', files={'image': open(image_path, 'rb')})
        ocr_data = ocr_response.json()
        print("result:", ocr_data)
        if 'response' in ocr_data and ocr_data['response'] == "Try uploading again. Model didn't extract properly.":
            return jsonify({'detections': "No Detection",'ocr_results': "No detection",'response': "Try uploading again. Model didn't extract properly."}), 400

        # Create annotated image with detections
        annotated_image = draw_boxes(image_path, detections)
        annotated_image_path = 'annotated_image.jpg'
        annotated_image.save(annotated_image_path)

        with open(annotated_image_path, 'rb') as f:
            annotated_image_data = f.read()

        response_data = {
            'detections': detections,
            'ocr_results': ocr_data,
            'response': "Detect Image has been created"  # Convert annotated image to hex string
        }

        return jsonify(response_data)
    

    @api.route('/test')
    class Test(Resource):
        def get(self):
            return {'message': 'Test successful'}, 200