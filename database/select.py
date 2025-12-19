from database.DBcm import DBContextManager
from flask import current_app


def select_list(_sql: str, param_list: list) -> tuple:
    with DBContextManager(current_app.config['db_config']) as cursor:
        result = None
        if type(cursor) == str:
            result = cursor
        elif cursor is None:
            raise ValueError("Cursor not defined")
        else:
            if param_list:
                cursor.execute(_sql, param_list)
                result = cursor.fetchall()
            else:
                cursor.execute(_sql)
                result = cursor.fetchall()
    return result


def select_dict(_sql: str, user_input: dict) -> tuple:
    user_list = []
    for key in user_input:
        user_list.append(user_input[key])
    print('user_list = in dict ', user_list)
    result = select_list(_sql, user_list)
    return result


def call_proc(proc, params):
    with DBContextManager(current_app.config['db_config']) as cursor:
        result = None
        if type(cursor) == str:
            result = cursor
        elif cursor is None:
            raise ValueError('Курсор не создан')
        else:
            cursor.callproc(proc, params)
            result = cursor.fetchall()
    return result
