from flask import Flask, render_template, request, jsonify
import pyodbc

app = Flask(__name__)

# Database connection settings
db_config = {
    'driver': 'SQL Server',
    'server': 'localhost\MSSQLSERVER01',
    'database': 'Database-001',
    'trusted_connection': 'yes'
}

def get_db_connection():
    return pyodbc.connect(
        f"DRIVER={{{db_config['driver']}}};SERVER={db_config['server']};DATABASE={db_config['database']};TRUSTED_CONNECTION={db_config['trusted_connection']}"
    )

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/tables')
def get_tables():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT name FROM sys.tables")
    tables = [row[0] for row in cursor.fetchall()]
    connection.close()
    return jsonify(tables)

@app.route('/api/data/<table>')
def get_table_data(table):
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM {table}")
    columns = [column[0] for column in cursor.description]
    rows = cursor.fetchall()
    connection.close()
    return jsonify({
        'columns': columns,
        'rows': [list(row) for row in rows]
    })

@app.route('/api/procedures')
def get_procedures():
    procedures = [
        "InsertCompany", "GetCompany", "UpdateCompany", "DeleteCompany", 
        "InsertCustomer", "GetCustomer", "UpdateCustomer", "DeleteCustomer", 
        "InsertDepartment", "GetDepartment", "UpdateDepartment", "DeleteDepartment", 
        "InsertItem", "GetItem", "UpdateItem", "DeleteItem", 
        "InsertService", "GetService", "UpdateService", "DeleteService"
    ]
    return jsonify(procedures)

@app.route('/api/views')
def get_views():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT name FROM sys.views")
    views = [row[0] for row in cursor.fetchall()]
    connection.close()
    return jsonify(views)

@app.route('/api/triggers')
def get_triggers():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT name FROM sys.triggers")
    triggers = [row[0] for row in cursor.fetchall()]
    connection.close()
    return jsonify(triggers)

@app.route('/api/run-procedure', methods=['POST'])
def run_procedure():
    data = request.json
    procedure_name = data['procedure_name']
    parameters = data.get('parameters', [])
    
    connection = get_db_connection()
    cursor = connection.cursor()
    query = f"EXEC {procedure_name} " + ', '.join(['?' for _ in parameters])
    try:
        cursor.execute(query, parameters)
        connection.commit()
        response = {'message': f'Procedure {procedure_name} executed successfully.'}
    except Exception as e:
        response = {'error': str(e)}
    finally:
        connection.close()
    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)

