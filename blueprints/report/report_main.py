import os.path
from flask import render_template, request, Blueprint

from blueprints.auth.access import group_required
from database.select import call_proc
from database.sql_provider import SQLProvider
from database.model_route import model_route


bp_report = Blueprint(
    'bp_report',
    __name__,
    template_folder='templates',
    static_folder='static'
)

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

@bp_report.route('/report', methods=['GET'])
@group_required
def report_menu():
    return render_template('report_menu.html')

@bp_report.route('/report/view', methods=['POST'])
@group_required
def report_view():
    sql_file = "report.sql"
    year = request.form['report_year']
    month = request.form['report_month']
    user_input = {"report_year" : year, "report_month" : month}
    result_info = model_route(provider, user_input, sql_file)
    if result_info.status:
        products = result_info.result
        prod_title = 'Результат запроса'
        return render_template('report.html', prod_title=prod_title, products=products)
    else:
        return render_template('order_status.html', message=result_info.err_message)

@bp_report.route('/report/create', methods=['POST'])
@group_required
def report_create():
    year = request.form['report_year']
    month = request.form['report_month']
    user_input = [year, month]
    print(year)
    result = call_proc('new_order_report', user_input)
    print(result)
    if result:
        return render_template('report_result.html', message=result[0][0])
    else:
        return render_template('order_status.html', message='Произошла ошибка при создании отчета')