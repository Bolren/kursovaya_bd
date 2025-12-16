import os
from flask import Blueprint, render_template, request, redirect, url_for, session, current_app
from database.sql_provider import SQLProvider
from blueprints.patients.model_patients import get_patients_without_ward, get_available_wards, assign_ward_to_patient

bp_patients = Blueprint(
    'bp_patients',
    __name__,
    template_folder='templates')

sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@bp_patients.route('/patients', methods=['GET', 'POST'])
def patients_menu():
    message = ''
    patients_result = get_patients_without_ward()
    patients = patients_result.result if patients_result.status else []

    wards_result = get_available_wards()
    available_wards = wards_result.result if wards_result.status else []

    if request.method == 'POST':
        patient_id = request.form.get('patient_id')
        ward_id = request.form.get('ward_id')

        if patient_id and ward_id:
            assign_result = assign_ward_to_patient(patient_id, ward_id)

            if assign_result.status:
                message = "Палата успешно назначена пациенту"
            else:
                message = f"Ошибка при назначении палаты: {assign_result.err_message}"

            return redirect(url_for('bp_patients.patients_menu'))

    return render_template('patients_list.html',
                           patients=patients,
                           available_wards=available_wards,
                           message=message)