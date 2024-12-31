$(document).ready(function () {
    // Load tables
    $.getJSON('/api/tables', function (data) {
        let tableList = $('#table-list');
        data.forEach(table => {
            tableList.append(`<li class="dropdown-item" onclick="loadTableData('${table}')">${table}</li>`);
        });
    });

    // Load procedures
    $.getJSON('/api/procedures', function (data) {
        let procedureList = $('#procedure-list');
        data.forEach(proc => {
            procedureList.append(`<li class="dropdown-item" onclick="runProcedure('${proc}')">${proc}</li>`);
        });
    });

    // Load views
    $.getJSON('/api/views', function (data) {
        let viewList = $('#view-list');
        data.forEach(view => {
            viewList.append(`<li class="dropdown-item" onclick="loadViewData('${view}')">${view}</li>`);
        });
    });

    // Load triggers
    $.getJSON('/api/triggers', function (data) {
        let triggerList = $('#trigger-list');
        data.forEach(trigger => {
            triggerList.append(`<li class="dropdown-item">${trigger}</li>`);
        });
    });
});

function loadTableData(table) {
    $.getJSON(`/api/data/${table}`, function (data) {
        let content = `<h3>${table}</h3><table class="table table-striped"><thead><tr>`;
        data.columns.forEach(col => {
            content += `<th>${col}</th>`;
        });
        content += `</tr></thead><tbody>`;
        data.rows.forEach(row => {
            content += `<tr>${row.map(val => `<td>${val}</td>`).join('')}</tr>`;
        });
        content += `</tbody></table>`;
        $('#main-content').html(content);
    });
}

function loadViewData(view) {
    $.getJSON(`/api/data/${view}`, function (data) {
        let content = `<h3>${view}</h3><table class="table table-striped"><thead><tr>`;
        data.columns.forEach(col => {
            content += `<th>${col}</th>`;
        });
        content += `</tr></thead><tbody>`;
        data.rows.forEach(row => {
            content += `<tr>${row.map(val => `<td>${val}</td>`).join('')}</tr>`;
        });
        content += `</tbody></table>`;
        $('#main-content').html(content);
    });
}

function runProcedure(procedure) {
    const params = prompt(`Enter parameters for ${procedure} (comma-separated):`);
    const paramList = params ? params.split(',') : [];
    $.ajax({
        url: '/api/run-procedure',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            procedure_name: procedure,
            parameters: paramList
        }),
        success: function (response) {
            alert(response.message || response.error);
        }
    });
}
