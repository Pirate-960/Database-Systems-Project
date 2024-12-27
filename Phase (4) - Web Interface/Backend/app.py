from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configuration for local SQL Server
app.config['SQLALCHEMY_DATABASE_URI'] = (
    'mssql+pyodbc://@localhost/<Database-001>?driver=ODBC+Driver+17+for+SQL+Server'
)

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize the database object
db = SQLAlchemy(app)

@app.route('/')
def index():
    return "Flask app is running in development mode!"

if __name__ == '__main__':
    # Enable debug mode for development
    app.run(debug=True)
