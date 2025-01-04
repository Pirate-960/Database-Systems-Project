// Global variables for modals
let procedureModal;
let resultsModal;
let currentProcedureInfo;

$(document).ready(function() {
    // Initialize Bootstrap modals
    procedureModal = new bootstrap.Modal(document.getElementById('procedureModal'));
    resultsModal = new bootstrap.Modal(document.getElementById('resultsModal'));

    // Initialize search functionality
    initializeSearch();
    
    // Load database objects
    loadTables();
    loadProcedures();
    loadViews();

    // Setup event handlers
    setupEventHandlers();
});


// Setup event handlers
function setupEventHandlers() {
    // Execute procedure button handler
    $('#executeProcedureBtn').on('click', function() {
        executeProcedure();
    });

    // Handle form submission (prevent default submission)
    $('#procedureForm').on('submit', function(e) {
        e.preventDefault();
        executeProcedure();
    });

    // Clear form when modal is hidden
    $('#procedureModal').on('hidden.bs.modal', function() {
        $('#procedureForm')[0].reset();
        $('#parametersContainer').empty();
        currentProcedureInfo = null;
    });
}

// Search functionality
function initializeSearch() {
    $('#searchBox').on('input', function() {
        const searchTerm = $(this).val().toLowerCase();
        filterItems('.list-group-item', searchTerm);
    });
}

function filterItems(selector, searchTerm) {
    $(selector).each(function() {
        const text = $(this).text().toLowerCase();
        $(this).toggle(text.includes(searchTerm));
    });
}

// Load database objects
function loadTables() {
    $.getJSON('/api/tables', function(tables) {
        const tableList = $('#table-list');
        tableList.empty();
        tables.forEach(table => {
            tableList.append(`
                <li class="list-group-item" onclick="loadTableData('${table}')">
                    <i class="fas fa-table me-2"></i>${table}
                </li>
            `);
        });
    }).fail(function(err) {
        showToast('Error loading tables: ' + err.responseJSON?.error || 'Unknown error', 'error');
    });
}

function loadProcedures() {
    $.getJSON('/api/procedures', function(procedures) {
        // Clear existing lists
        $('#insert-procedure-list, #get-procedure-list, #update-procedure-list, #delete-procedure-list').empty();
        
        procedures.forEach(proc => {
            const procedureName = `${proc.schema}.${proc.name}`;
            const displayName = proc.name;
            let listElement = `
                <li class="list-group-item" onclick="showProcedureModal('${procedureName}')">
                    <i class="fas fa-cog me-2"></i>${displayName}
                    <span class="badge bg-light text-dark float-end">${proc.parameter_count} params</span>
                </li>
            `;
            
            // Add to appropriate category
            if (displayName.toLowerCase().startsWith('insert')) {
                $('#insert-procedure-list').append(listElement);
            } else if (displayName.toLowerCase().startsWith('get')) {
                $('#get-procedure-list').append(listElement);
            } else if (displayName.toLowerCase().startsWith('update')) {
                $('#update-procedure-list').append(listElement);
            } else if (displayName.toLowerCase().startsWith('delete')) {
                $('#delete-procedure-list').append(listElement);
            }
        });
    }).fail(function(err) {
        showToast('Error loading procedures: ' + err.responseJSON?.error || 'Unknown error', 'error');
    });
}

function loadViews() {
    $.getJSON('/api/views', function(views) {
        const viewList = $('#view-list');
        viewList.empty();
        views.forEach(view => {
            const viewName = `${view.schema}.${view.name}`;
            viewList.append(`
                <li class="list-group-item" onclick="loadViewData('${viewName}')">
                    <i class="fas fa-eye me-2"></i>${view.name}
                </li>
            `);
        });
    }).fail(function(err) {
        showToast('Error loading views: ' + err.responseJSON?.error || 'Unknown error', 'error');
    });
}

// Procedure handling
async function showProcedureModal(procedureName) {
    try {
        const response = await fetch(`/api/procedure/${encodeURIComponent(procedureName.split('.')[1])}/info`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        currentProcedureInfo = await response.json();
        
        if (!currentProcedureInfo || currentProcedureInfo.error) {
            throw new Error(currentProcedureInfo?.error || 'Failed to load procedure information');
        }

        // Update modal content
        $('#procedureName').val(procedureName);  // Store full schema.name
        $('#procedureDescription').html(generateProcedureDescription(currentProcedureInfo));
        $('#parametersContainer').html(generateParameterFields(currentProcedureInfo));
        
        // Show the modal
        procedureModal.show();
    } catch (error) {
        showToast('Error loading procedure information: ' + error.message, 'error');
    }
}

function generateProcedureDescription(procInfo) {
    const type = getProcedureType(procInfo.name);
    return `
        <div class="mb-2">
            <span class="badge bg-primary">${type}</span>
            <span class="badge bg-secondary">${procInfo.parameters.length} Parameters</span>
        </div>
        <p class="mb-0">This procedure will ${getProcedureDescription(procInfo.name, type)}.</p>
    `;
}

function generateParameterFields(procInfo) {
    let html = '';
    procInfo.parameters.forEach((param, index) => {
        html += `
            <div class="parameter-field">
                <div class="form-group">
                    <label class="form-label ${param.is_nullable ? '' : 'required-field'}">
                        ${formatParameterName(param.name)}
                    </label>
                    ${generateInputField(param, index)}
                    <div class="parameter-help">
                        Type: ${param.type}${param.max_length > 0 ? `, Max Length: ${param.max_length}` : ''}
                    </div>
                </div>
            </div>
        `;
    });
    return html;
}

function generateInputField(param, index) {
    const inputName = `param_${index}`;
    const required = !param.is_nullable ? 'required' : '';
    
    switch(param.type.toLowerCase()) {
        case 'bit':
            return `
                <select class="form-select" name="${inputName}" ${required}>
                    <option value="">Select...</option>
                    <option value="1">True</option>
                    <option value="0">False</option>
                </select>
            `;
        case 'date':
            return `<input type="date" class="form-control" name="${inputName}" ${required}>`;
        case 'datetime':
            return `<input type="datetime-local" class="form-control" name="${inputName}" ${required}>`;
        case 'int':
        case 'bigint':
        case 'smallint':
        case 'tinyint':
            return `<input type="number" class="form-control" name="${inputName}" ${required}>`;
        case 'decimal':
        case 'numeric':
        case 'float':
        case 'real':
            return `<input type="number" step="any" class="form-control" name="${inputName}" ${required}>`;
        default:
            return `<input type="text" class="form-control" name="${inputName}" 
                    ${param.max_length ? `maxlength="${param.max_length}"` : ''} ${required}>`;
    }
}

async function executeProcedure() {
    try {
        // Validate required fields
        const form = $('#procedureForm')[0];
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const parameters = [];
        
        currentProcedureInfo.parameters.forEach((param, index) => {
            let value = formData.get(`param_${index}`);
            
            // Handle different parameter types
            if (value === '') {
                value = null;
            } else if (param.type.toLowerCase() === 'bit') {
                value = value === '1';
            } else if (['int', 'bigint', 'smallint', 'tinyint'].includes(param.type.toLowerCase())) {
                value = parseInt(value);
            } else if (['decimal', 'numeric', 'float', 'real'].includes(param.type.toLowerCase())) {
                value = parseFloat(value);
            }
            
            parameters.push(value);
        });

        const requestBody = {
            procedure_name: $('#procedureName').val(),
            parameters: parameters
        };

        console.log('Sending request:', requestBody); // Debug log

        const response = await fetch('/api/run-procedure', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(requestBody)
        });

        // Check the content type of the response
        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            // If it's not JSON, get the text and log it for debugging
            const textResponse = await response.text();
            console.error('Received non-JSON response:', textResponse);
            throw new Error('Server returned an invalid response format');
        }
        
        const result = await response.json();
        
        if (!response.ok) {
            throw new Error(result.error || `Server error: ${response.status}`);
        }
        
        if (result.error) {
            throw new Error(result.error);
        }
        
        // Hide procedure modal
        procedureModal.hide();
        
        // Show results
        if (result.results) {
            displayResults(result);
        } else {
            showToast(result.message || 'Procedure executed successfully', 'success');
        }
    } catch (error) {
        console.error('Procedure execution error:', error);
        showToast('Error executing procedure: ' + error.message, 'error');
    }
}

// View handling
function loadViewData(viewName) {
    $.getJSON(`/api/data/${encodeURIComponent(viewName)}`, function(data) {
        const content = generateDataTable(data, viewName.split('.')[1]);  // Display just the view name
        $('#main-content').html(content);
    }).fail(function(jqXHR) {
        showToast(`Error loading view: ${jqXHR.responseJSON?.error || 'Unknown error'}`, 'error');
    });
}

function displayResults(result) {
    const resultsContainer = $('#resultsContainer');
    resultsContainer.empty();
    
    if (!result.results) {
        resultsContainer.append(`<div class="alert alert-info">No results returned</div>`);
        return;
    }

    // Handle both array and single result set formats
    const resultSets = Array.isArray(result.results) ? result.results : [result.results];
    
    if (resultSets.length === 0) {
        resultsContainer.append(`<div class="alert alert-info">Procedure executed successfully with no result sets</div>`);
        return;
    }

    resultSets.forEach((resultSet, index) => {
        if (!resultSet || (!resultSet.columns && !resultSet.rows)) {
            resultsContainer.append(`<div class="alert alert-warning">Result set ${index + 1} is empty or invalid</div>`);
            return;
        }
        resultsContainer.append(generateResultTable(resultSet, index));
    });

    resultsModal.show();
}

function generateResultTable(resultSet, index) {
    let html = `
        <div class="results-table-wrapper">
            <h6>Result Set ${index + 1}</h6>
            <table class="table table-striped">
                <thead>
                    <tr>
                        ${resultSet.columns.map(col => `<th>${col}</th>`).join('')}
                    </tr>
                </thead>
                <tbody>
                    ${resultSet.rows.map(row => `
                        <tr>${row.map(cell => `<td>${formatCell(cell)}</td>`).join('')}</tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `;
    return html;
}

// Utility functions
function formatParameterName(name) {
    return name.replace('@', '').split('_').map(word => 
        word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
    ).join(' ');
}

// Helper function to safely format cell values
function formatCell(value) {
    if (value === null || value === undefined) {
        return '<em class="text-muted">NULL</em>';
    }
    if (value instanceof Date) {
        return value.toLocaleString();
    }
    if (typeof value === 'object') {
        try {
            return JSON.stringify(value);
        } catch (e) {
            return String(value);
        }
    }
    // Escape HTML to prevent XSS
    const text = String(value);
    return text.replace(/[&<>"']/g, char => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;'
    }[char]));
}

function showToast(message, type = 'info') {
    const toast = `
        <div class="toast ${type} align-items-center" role="alert">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'} me-2"></i>
                    ${message}
                </div>
                <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `;
    
    $('#toastContainer').append(toast);
    const toastElement = new bootstrap.Toast($('#toastContainer .toast').last());
    toastElement.show();
    
    // Remove toast after it's hidden
    toastElement._element.addEventListener('hidden.bs.toast', function() {
        $(this).remove();
    });
}

// Data loading functions
function loadTableData(table) {
    $.getJSON(`/api/data/${table}`, function(data) {
        const content = generateDataTable(data, table);
        $('#main-content').html(content);
    }).fail(function(jqXHR, textStatus, errorThrown) {
        showToast(`Error loading table: ${errorThrown}`, 'error');
    });
}

function generateDataTable(data, title) {
    return `
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3>${title}</h3>
            <button class="btn btn-outline-primary" onclick="exportToCSV('${title}')">
                <i class="fas fa-download me-2"></i>Export to CSV
            </button>
        </div>
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>${data.columns.map(col => `<th>${col}</th>`).join('')}</tr>
                </thead>
                <tbody>
                    ${data.rows.map(row => `
                        <tr>${row.map(cell => `<td>${formatCell(cell)}</td>`).join('')}</tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `;
}

function exportToCSV(title) {
    const rows = [];
    const table = document.querySelector('.table');
    
    // Get headers
    const headers = Array.from(table.querySelectorAll('th')).map(th => th.textContent);
    rows.push(headers);
    
    // Get data rows
    const dataRows = Array.from(table.querySelectorAll('tbody tr')).map(row => 
        Array.from(row.querySelectorAll('td')).map(cell => cell.textContent)
    );
    rows.push(...dataRows);
    
    // Convert to CSV
    const csv = rows.map(row => row.map(cell => `"${cell}"`).join(',')).join('\n');
    
    // Download
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.setAttribute('hidden', '');
    a.setAttribute('href', url);
    a.setAttribute('download', `${title}_${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
}

// Helper function to determine procedure type based on name
function getProcedureType(procedureName) {
    procedureName = procedureName.toLowerCase();
    if (procedureName.startsWith('get')) return 'SELECT';
    if (procedureName.startsWith('insert')) return 'INSERT';
    if (procedureName.startsWith('update')) return 'UPDATE';
    if (procedureName.startsWith('delete')) return 'DELETE';
    return 'EXECUTE';
}

// Helper function to generate a human-readable description of the procedure
function getProcedureDescription(procedureName, type) {
    procedureName = procedureName.toLowerCase();
    const nameWithoutPrefix = procedureName.replace(/^(get|insert|update|delete)_?/, '');
    const formattedName = nameWithoutPrefix
        .split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');

    switch (type) {
        case 'SELECT':
            return `retrieve ${formattedName} data`;
        case 'INSERT':
            return `create a new ${formattedName} record`;
        case 'UPDATE':
            return `modify existing ${formattedName} data`;
        case 'DELETE':
            return `remove ${formattedName} data`;
        default:
            return `execute ${formattedName}`;
    }
}