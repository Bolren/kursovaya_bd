import os
from flask import Blueprint, render_template, request, redirect, url_for, flash

from access import group_required
from database.model_route import model_route
from database.sql_provider import SQLProvider


bp_patients = Blueprint(
    'bp_patients',
    __name__,
    static_folder='static',
    template_folder='templates',
    static_url_path='/patients-static'
)

sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@bp_patients.route('/patients', methods=['GET'])
@group_required
def patients_menu():
    patients_sql = 'patients_without_ward.sql'
    wards_sql = 'available_wards.sql'
    patients_result = model_route(sql_provider, {}, patients_sql)
    wards_result = model_route(sql_provider, {}, wards_sql)
    print(patients_result.result)
    print(wards_result.result)
    if patients_result.status and wards_result.status or patients_result.result == () or wards_result.result == ():
        return render_template('patients_list.html',
                               patients=patients_result.result,
                               available_wards=wards_result.result)
    else:
        message = patients_result.err_message if not patients_result.status else wards_result.err_message
        return render_template('error_patients.html', message=message)

@bp_patients.route('/patients_add', methods=['POST'])
def add_patient_to_ward():
    patient_id = request.form.get('patient_id')
    ward_id = request.form.get('ward_id')
    user_input = {"patient_id": patient_id, "ward_id": ward_id}
    assign_sql = 'assign_ward.sql'

    assign_result = model_route(sql_provider, user_input, assign_sql)

    if assign_result.status:
        message = "Палата успешно назначена пациенту"
        flash(message)
        return redirect(url_for('bp_patients.patients_menu'))
    else:
        message = f"Ошибка при назначении палаты: {assign_result.err_message}"
        flash(message)
        return redirect(url_for('bp_patients.patients_menu'))

