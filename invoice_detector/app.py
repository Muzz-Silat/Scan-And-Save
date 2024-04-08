from flask import Flask, request, jsonify
from api_v1 import blueprint as api_v1
from tensorflow.keras.models import load_model
import numpy as np
import joblib

app = Flask(__name__)
app.register_blueprint(api_v1)

# Load the saved model and scaler for the new prediction functionality
model = load_model('../best_grocery_model.h5')
scaler = joblib.load('../grocery_scaler.gz')

def smooth_expenses(expensesList, window_size=3):
    smoothed_expenses = expensesList.copy()
    for i in range(1, len(expensesList)-1):
        if expensesList[i] == 0:  # If current day has zero expenses
            surrounding_sum = sum(expensesList[i-window_size:i] + expensesList[i+1:i+1+window_size])
            surrounding_count = len([e for e in expensesList[i-window_size:i] + expensesList[i+1:i+1+window_size] if e != 0])
            if surrounding_count > 0:
                smoothed_expenses[i] = surrounding_sum / surrounding_count  # Average non-zero surrounding expenses
    return smoothed_expenses

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    
    if 'expenses' in data and len(data['expenses']) == 30:
        smoothed_expenses = smooth_expenses(data['expenses'])
        last_30_days = np.array(smoothed_expenses).reshape(-1, 1)
        last_30_days_scaled = scaler.transform(last_30_days).reshape(1, 30, 1)
        prediction_scaled = model.predict(last_30_days_scaled)
        predicted_expense = scaler.inverse_transform(prediction_scaled)
        return jsonify({'predicted_expense': predicted_expense[0, 0].tolist()})
    else:
        return jsonify({'error': 'Invalid input data. Please provide a list of 30 raw expenses.'}), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

