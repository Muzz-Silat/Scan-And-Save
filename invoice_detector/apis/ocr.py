from flask_restx import Namespace, Resource
from flask import Flask, request, jsonify, make_response
import easyocr
from PIL import ImageDraw, Image
import os
from openai import OpenAI
import json
import apis.config
import io
import tempfile
import json.decoder

api = Namespace('easyOCR', description='Extraction data from Invoice(Implementation2)')
os.environ["OPENAI_API_KEY"] = apis.config.open_ai_api_key

llm = OpenAI()

# Initialize EasyOCR reader
reader = easyocr.Reader(['en'], gpu=False)

import tempfile

def extract_data(image_data):
    # Save the image data to a temporary file
    with tempfile.NamedTemporaryFile(suffix='.png', delete=False) as temp_image_file:
        temp_image_path = temp_image_file.name
        image_data.save(temp_image_path)

    try:
        # Doing OCR. Get bounding boxes.
        bounds = reader.readtext(temp_image_path)

        # Draw bounding boxes
        im = Image.open(temp_image_path)
        draw = ImageDraw.Draw(im)
        for bound in bounds:
            p0, p1, p2, p3 = bound[0]
            draw.line([*p0, *p1, *p2, *p3, *p0], fill='yellow', width=2)

        output = ""
        product_prices = []
        product_names = []

        for i in bounds:
            output += i[1] + "\n"

        prompt = f"""Please extract all the product prices not Total and put them into a product price array. Then, find the highest number in the whole data and assign it to the 'Total' variable.
        Next, analyze the data to identify the product names mentioned and put them into a product name array."""
        completion = llm.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are an AI assistant"},
                {"role": "user", "content": f"""Data: ${output}\n\n${prompt}"""}
            ]
        )
        response = completion.choices[0].message.content
        completion = llm.chat.completions.create(
                    model="gpt-4",
                    messages=[
                    {"role": "system", "content": "You are an AI assistant"},
                    {"role": "user", "content": f"""Data: ${response}\n\n"Please analyze the provided data to extract product prices and names. For each product, remove any currency symbols from the prices and list them separately. Ensure that the total sum of all product prices is calculated. Format your response as a JSON object with three keys: 'PRODUCT PRICES', 'PRODUCT NAMES', and 'TOTAL'. The 'PRODUCT PRICES' key should contain a list of numerical values representing the prices of the products. The 'PRODUCT NAMES' key should contain a list of strings representing the names of the products. The 'TOTAL' key should contain a single numerical value representing the sum of all product prices. Ensure that the number of items under 'PRODUCT PRICES' matches the number of 'PRODUCT NAMES', and that all information is accurately represented. Never provide any additional details or formatting from your response, focusing solely on providing the requested information under the specified keys."""}
                    ]
                    )
        print(completion.choices[0].message.content)
        output_data = json.loads(completion.choices[0].message.content)

        # Extract variables
        product_prices = output_data["PRODUCT PRICES"]
        product_names = output_data["PRODUCT NAMES"]
        total = output_data["TOTAL"]

        # Clean up temporary file
        os.remove(temp_image_path)

        return {
            "Product Prices": product_prices,
            "Product Names": product_names,
            "Total": total
        }

    except json.decoder.JSONDecodeError as e:
        # Clean up temporary file
        os.remove(temp_image_path)
        
        # Return error message
        return {
            "response": "Try uploading again. Model didn't extract properly."
        }


@api.route('/analyze_invoice')
class InvoiceOCR(Resource):
    def post(self):
        if 'image' not in request.files:
            return make_response(jsonify({"error": "No image found in request"}), 400)

        image = request.files['image']
        print("Image:", image)
        if image.filename == '':
            return make_response(jsonify({"error": "No selected file"}), 400)

        result = extract_data(image)
        return make_response(jsonify(result), 200)