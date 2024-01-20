from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

# Function for the default route
@app.route('/')
def default():
    return "Default route. Use /health, /diag, or /convert for specific endpoints."

# Function to get health status
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

# Function to check API status
@app.route('/diag', methods=['GET'])
def diag():
    try:
        api_status = requests.get("https://www.travel-advisory.info/api").json()
        return jsonify({"api_status": {"code": 200, "status": "ok"}})
    except Exception as e:
        return jsonify({"api_status": {"code": 500, "status": "error", "message": str(e)}})

# Function to convert country name to country code
@app.route('/convert', methods=['GET'])
def convert():
    try:
        country_name = request.args.get('country')
        country_info = requests.get(f"https://restcountries.com/v2/name/{country_name}").json()
        
        if country_info and country_info[0].get('alpha2Code'):
            country_code = country_info[0]['alpha2Code']
            return jsonify({"country_code": country_code})
        else:
            return jsonify({"error": "Country code not found"})
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080
