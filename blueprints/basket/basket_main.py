import os

from flask import Blueprint, render_template, request, redirect, url_for, session, current_app
from database.sql_provider import SQLProvider
from blueprints.basket.model_products import get_all_products, get_product_by_id, insert_many

bp_basket = Blueprint(
    'bp_basket',
    __name__,
    template_folder='templates')

sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@bp_basket.route('/basket', methods=['GET', 'POST'])
def basket_menu():
    if 'basket' not in session:
        session['basket'] = {}

    if request.method == 'POST':
        prod_id = request.form.get('prod_id')
        if prod_id is not None:
            product_info = get_product_by_id(sql_provider, int(prod_id))
            if product_info.status:
                product = product_info.result
                basket = session['basket']
                key = str(product['prod_id'])

                if key in basket:
                    basket[key]['amount'] += 1
                else:
                    basket[key] = {
                        'prod_id': product['prod_id'],
                        'prod_name': product['prod_name'],
                        'prod_price': product['prod_price'],
                        'amount': 1
                    }

                session['basket'] = basket

        return redirect(url_for('bp_basket.basket_menu'))

    products_info = get_all_products(sql_provider)
    items = products_info.result if products_info.status else []

    basket = session.get('basket', {})
    return render_template('basket_order_list.html',
                           items=items,
                           basket=basket)


@bp_basket.route('/clear_basket')
def clear_basket():
    session['basket'] = {}
    return redirect(url_for('bp_basket.basket_menu'))


@bp_basket.route('/save_basket')
def save_basket():
    basket = session.get('basket', {})
    if not basket:
        return render_template("order_status.html", message="Корзина пуста, оформлять нечего")

    user_id = session.get('user_id')
    if user_id is None:
        return render_template("order_status.html", message="Пользователь не авторизован")

    order_id = insert_many(basket, user_id)
    if order_id is None:
        return render_template("order_status.html", message="Ошибка при сохранении заказа")

    session['basket'] = {}
    return render_template("order_status.html", message=f'Заказ №{order_id} оформлен!')
