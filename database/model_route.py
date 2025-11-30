from dataclasses import dataclass
from database.select import select_dict

@dataclass
class ResultInfo:
    result: tuple
    status: bool
    err_message: str

def model_route(provider, user_input: dict, sql: str):
    err_message = ''
    _sql = provider.get(sql)
    result = select_dict(_sql, user_input)
    if type(result) == str:
        err_message = result
        return ResultInfo(result, False, err_message)
    elif result:
        return ResultInfo(result, True, err_message)
    else:
        err_message = 'Данные не получены или отсутствуют в БД'
        return ResultInfo(result, False, err_message)