import os
from dataclasses import dataclass
from datetime import date

from flask import current_app, session

from database.DBcm import DBContextManager
from database.select import select_dict   # твоя функция
from database.sql_provider import SQLProvider


@dataclass
class ResultInfoProduct:
    result: dict
    status: bool
    err_message: str

sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))

def insert_many(basket, user_id):
    insert_order_sql = sql_provider.get('insert_order.sql')
    insert_item_sql = sql_provider.get('insert_order_item.sql')

    with DBContextManager(current_app.config['db_config']) as cursor:
        if cursor is None:
            raise ValueError("Cursor not defined")

        try:
            today = date.today()
            cursor.execute(insert_order_sql, (user_id, today))
            order_id = cursor.lastrowid

            for item in basket.values():
                cursor.execute(
                    insert_item_sql,
                    (order_id, item['prod_id'], item['amount'])
                )

        except Exception as e:
            print('Ошибка при сохранении заказа:', e)
            order_id = None

    return order_id

def row_to_product_dict(row):
    return {
        'prod_id': row[0],
        'prod_name': row[1],
        'prod_price': row[2],
        'prod_measure': row[3],
        'prod_category': row[4],
    }


def get_all_products(provider):
    err_message = ''
    _sql = provider.get('products_all.sql')
    rows = select_dict(_sql, {})

    if rows:
        products = [row_to_product_dict(row) for row in rows]
        return ResultInfoProduct(products, True, err_message)
    else:
        err_message = 'Товары не найдены'
        return ResultInfoProduct([], False, err_message)


def get_product_by_id(provider, prod_id: int):
    err_message = ''
    _sql = provider.get('product_by_id.sql')
    rows = select_dict(_sql, {'prod_id': prod_id})

    if rows:
        product = row_to_product_dict(rows[0])
        return ResultInfoProduct(product, True, err_message)
    else:
        err_message = 'Товар не найден'
        return ResultInfoProduct({}, False, err_message)


