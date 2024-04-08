from flask import Blueprint
from flask_restx import Api
from apis.ocr import api as invoice_ocr
from apis.invoice_detection import api as detector


blueprint = Blueprint('api', __name__, url_prefix='/')
api = Api(blueprint,
    title='Invoice OCR',
    version='1.0',
    description='Extract Product Names, Prices and Total',
)

api.add_namespace(invoice_ocr)
api.add_namespace(detector)
