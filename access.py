from functools import wraps
from flask import session, url_for, redirect, request, current_app, app, render_template


def login_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if 'user_group' in session:
            return func(*args, **kwargs)
        else:
            return redirect(url_for('bp_auth.auth'))
    return wrapper

def group_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if 'user_group' in session:
            access = current_app.config['db_access']
            user_request = request.endpoint
            print(f'endpoint = {request.endpoint}, user_request = {user_request}')
            user_role = session.get('user_group')
            print(f'user_role: {user_role}, user_request: {user_request}, access[user_role]: {access[user_role]}')
            if user_role in access and user_request in access[user_role]:
                return func(*args, **kwargs)
            else:
                return render_template('access_denied.html')
        return redirect(url_for('bp_auth.auth'))

    return wrapper