from flask import Flask, render_template, request, jsonify
import pyodbc
from datetime import datetime
import traceback

app = Flask(__name__)

# Database connection settings
db_config = {
    'driver': 'SQL Server',
    'server': 'localhost\\MSSQLSERVER01',
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
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT name FROM sys.tables")
        tables = [row[0] for row in cursor.fetchall()]
        connection.close()
        return jsonify(tables)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/data/<path:table>')
def get_table_data(table):
    try:
        schema, table_name = table.split('.') if '.' in table else ('dbo', table)
        connection = get_db_connection()
        cursor = connection.cursor()
        # Add SQL injection prevention
        cursor.execute("""
            SELECT name 
            FROM sys.objects 
            WHERE object_id = OBJECT_ID(?) 
            AND type in ('U','V')
        """, (f"{schema}.{table_name}",))
        if not cursor.fetchone():
            return jsonify({'error': 'Table or view not found'}), 404
        
        cursor.execute(f"SELECT * FROM {schema}.{table_name}")
        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        connection.close()
        return jsonify({
            'columns': columns,
            'rows': [list(row) for row in rows]
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/views')
def get_views():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            SELECT SCHEMA_NAME(schema_id) as schema_name,
                   name,
                   OBJECT_DEFINITION(object_id) as definition
            FROM sys.views
            ORDER BY schema_name, name
        """)
        views = []
        for row in cursor.fetchall():
            views.append({
                'name': row.name,
                'schema': row.schema_name,
                'definition': row.definition
            })
        connection.close()
        return jsonify(views)
    except Exception as e:
        return jsonify({'error': f'Error loading views: {str(e)}'}), 500

@app.route('/api/procedures')
def get_procedures():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            SELECT SCHEMA_NAME(schema_id) as schema_name,
                   name,
                   parameter_count = (
                       SELECT COUNT(*)
                       FROM sys.parameters
                       WHERE object_id = p.object_id
                   ),
                   OBJECT_ID(SCHEMA_NAME(schema_id) + '.' + name) as proc_id
            FROM sys.procedures p
            ORDER BY schema_name, name
        """)
        procedures = []
        for row in cursor.fetchall():
            # Get parameter information for each procedure
            cursor.execute("""
                SELECT  name,
                        type_name(user_type_id) as parameter_type,
                        max_length,
                        is_nullable
                FROM sys.parameters
                WHERE object_id = ?
                ORDER BY parameter_id
            """, row.proc_id)
            
            parameters = []
            for param in cursor.fetchall():
                parameters.append({
                    'name': param.name,
                    'type': param.parameter_type,
                    'max_length': param.max_length,
                    'is_nullable': param.is_nullable
                })
            
            procedures.append({
                'name': row.name,
                'schema': row.schema_name,
                'parameter_count': row.parameter_count,
                'parameters': parameters
            })
        
        connection.close()
        return jsonify(procedures)
    except Exception as e:
        return jsonify({'error': f'Error loading procedures: {str(e)}'}), 500

@app.route('/api/procedure/<name>/info')
def get_procedure_info(name):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        # First, get the schema name for the procedure
        cursor.execute("""
            SELECT SCHEMA_NAME(schema_id) as schema_name, 
                   name,
                   OBJECT_ID(SCHEMA_NAME(schema_id) + '.' + name) as proc_id
            FROM sys.procedures 
            WHERE name = ?
        """, name)
        
        proc_info = cursor.fetchone()
        if not proc_info:
            return jsonify({'error': 'Procedure not found'}), 404
            
        # Get procedure parameters
        cursor.execute("""
            SELECT  name,
                    type_name(user_type_id) as parameter_type,
                    max_length,
                    is_nullable
            FROM sys.parameters
            WHERE object_id = ?
            ORDER BY parameter_id
        """, proc_info.proc_id)
        
        parameters = []
        for row in cursor.fetchall():
            parameters.append({
                'name': row.name,
                'type': row.parameter_type,
                'max_length': row.max_length,
                'is_nullable': row.is_nullable
            })
            
        connection.close()
        return jsonify({
            'name': name,
            'schema': proc_info.schema_name,
            'parameters': parameters
        })
    except Exception as e:
        return jsonify({'error': f'Error loading procedure information: {str(e)}'}), 500

@app.route('/api/run-procedure', methods=['POST'])
def execute_procedure():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
            
        procedure_name = data.get('procedure_name')
        parameters = data.get('parameters', [])
        
        if not procedure_name:
            return jsonify({'error': 'No procedure name provided'}), 400

        # Connect to your database
        conn = get_db_connection()  # You should have this function defined
        cursor = conn.cursor()
        
        # Prepare the SQL statement
        param_placeholders = ','.join(['?' for _ in parameters])
        sql = f"EXEC {procedure_name} {param_placeholders}"
        
        # Execute the procedure and fetch results
        cursor.execute(sql, parameters)
        
        results = []
        while True:
            try:
                columns = [column[0] for column in cursor.description]
                rows = cursor.fetchall()
                results.append({
                    'columns': columns,
                    'rows': [[str(cell) if cell is not None else None for cell in row] for row in rows]
                })
                
                # Move to the next result set if any
                if not cursor.nextset():
                    break
            except:
                break
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'results': results,
            'message': 'Procedure executed successfully'
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/triggers')
def get_triggers():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            SELECT 
                t.name as trigger_name,
                OBJECT_NAME(t.parent_id) as table_name,
                SCHEMA_NAME(t.schema_id) as schema_name,
                OBJECTPROPERTY(t.object_id, 'ExecIsAfterTrigger') as is_after,
                OBJECTPROPERTY(t.object_id, 'ExecIsInsteadOfTrigger') as is_instead_of,
                OBJECTPROPERTY(t.object_id, 'ExecIsTriggerDisabled') as is_disabled
            FROM sys.triggers t
            WHERE t.parent_class = 1  -- Object triggers only
            ORDER BY schema_name, table_name, trigger_name
        """)
        triggers = []
        for row in cursor.fetchall():
            triggers.append({
                'name': row.trigger_name,
                'table': row.table_name,
                'schema': row.schema_name,
                'type': 'INSTEAD OF' if row.is_instead_of else 'AFTER',
                'status': 'Disabled' if row.is_disabled else 'Enabled'
            })
        connection.close()
        return jsonify(triggers)
    except Exception as e:
        return jsonify({'error': f'Error loading triggers: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(debug=True)