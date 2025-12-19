import os.path
from flask import render_template, request, Blueprint, current_app

from access import group_required
from database.select import call_proc
from database.sql_provider import SQLProvider
from database.model_route import model_route


bp_report = Blueprint(
    'bp_report',
    __name__,
    template_folder='templates',
    static_folder='static',
    static_url_path='/report-static',
)

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

@bp_report.route('/report', methods=['GET'])
@group_required
def report_menu():
    types = current_app.config['report_types']
    return render_template('report_menu.html', types=types)

@bp_report.route('/report/view', methods=['POST'])
@group_required
def report_view():
    report_id = request.form.get('report_id')
    print(request.form)
    if not report_id:
        return render_template('error_report.html', message="Такого запроса не существует")

    types = current_app.config['report_types']
    report_info = types.get(report_id)

    sql_file = report_info['report_view_file']
    tabs_result = report_info['tabs_result']

    year = request.form['report_year']
    month = request.form['report_month']
    user_input = {"report_year" : year, "report_month" : month}

    result_info = model_route(provider, user_input, sql_file)
    if result_info.status:
        return render_template('report_result.html',
                               results=tabs_result,
                               data=result_info.result,
                               variant="view")
    else:
        return render_template('error_report.html', message=result_info.err_message)

@bp_report.route('/report/create', methods=['POST'])
@group_required
def report_create():
    report_id = request.form.get('report_id')
    print(request.form)
    if not report_id:
        return render_template('error_report.html', message="Такого запроса не существует")

    types = current_app.config['report_types']
    report_info = types.get(report_id)

    procedure = report_info['report_create_file']

    year = request.form['report_year']
    month = request.form['report_month']
    user_input = [year, month]

    result = call_proc(procedure, user_input)
    print(result)
    if result:
        return render_template('report_result.html',
                               message=result[0][0],
                               variant="create")
    else:
        return render_template('error_report.html', message='Произошла ошибка при создании отчета')