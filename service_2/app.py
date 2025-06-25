from flask import Flask
import os

app = Flask(__name__)

@app.route('/health')
def health():
    return "Service 2 (Python) is healthy", 200

@app.route('/')
def hello():
    return "Hello from Python Service 2!", 200

# Add your existing routes here...
# Example:
# @app.route('/api/data')
# def get_data():
#     return {"message": "Data from Python service"}

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 8002))
    print(f"Python service starting on port {port}")
    app.run(host='0.0.0.0', port=port, debug=False)