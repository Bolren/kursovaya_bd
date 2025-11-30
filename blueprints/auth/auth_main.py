import os.path
from flask import render_template, request, Blueprint, redirect, url_for, session
from database.sql_provider import SQLProvider
from database.model_route import model_route


bp_auth = Blueprint(
    'bp_auth',
    __name__,
    template_folder='templates',
    static_folder='static'
)

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

@bp_auth.route('/auth', methods=['GET'])
def auth_index():
    return render_template('auth_index.html')

@bp_auth.route('/auth', methods=['POST'])
def auth_result():
    user_input = request.form
    sql_file = "login.sql"
    print('request.form =', request.form)
    result_info = model_route(provider, user_input, sql_file)
    if result_info.status:
        session['user_group'] = result_info.result[0][0]
        session['user_id'] = result_info.result[0][1]
        return redirect(url_for('main_menu'))
    else:
        return render_template('auth_index.html', again=True)