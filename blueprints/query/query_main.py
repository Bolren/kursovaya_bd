import os

from flask import Blueprint, render_template, request, current_app

from blueprints.auth.access import group_required
from database.sql_provider import SQLProvider
from database.model_route import model_route

bp_query = Blueprint(
    'bp_query',
    __name__,
    template_folder='templates',
    static_folder='static'
)

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

@bp_query.route('/query')
@group_required
def query_choose():
    types = current_app.config['query_types']
    return render_template('query_choose.html', types=types)

@bp_query.route('/query', methods=['POST'])
def query_form():
    query_id = request.form.get('query_id')
    print(request.form)
    if not query_id:
        return render_template('error.html', message="Такого запроса не существует")

    types = current_app.config['query_types']
    query_info = types.get(query_id)

    data = [query_info['title_form'], query_info['tabs_form']]
    return render_template("query_form.html", data=data, query_id=query_id)

@bp_query.route('/query_result', methods=['POST'])
@group_required
def query_result():
    types = current_app.config['query_types']

    query_id = request.form.get('query_id')
    query_info = types.get(query_id)

    sql, tabs_form, tabs_result = query_info['sql_file'], query_info['tabs_form'], query_info['tabs_result']
    user_input = request.form.to_dict()
    user_input.pop('query_id', None)

    result_info = model_route(provider, user_input, sql)
    print(result_info)
    if result_info.status:
        return render_template("query_result.html", results=tabs_result, data=result_info.result)
    else:
        return render_template("error.html", message=result_info.err_message)


