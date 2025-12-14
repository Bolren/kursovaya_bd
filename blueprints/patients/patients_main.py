import os
from flask import Blueprint, render_template, request, redirect, url_for, session, current_app
from database.sql_provider import SQLProvider
from blueprints.patients.model_patients import get_all_patients, get_patient_by_id, add_patient, discharge_patient

bp_patients = Blueprint(
    'bp_patients',
    __name__,
    template_folder='templates')

sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@bp_patients.route('/patients', methods=['GET', 'POST'])
def patients_menu():
    if request.method == 'POST':
        # Обработка добавления нового пациента
        surname = request.form.get('surname')
        passport = request.form.get('passport')
        address = request.form.get('address')
        birthday = request.form.get('birthday')
        ward_id = request.form.get('ward_id')
        doc_id = request.form.get('doc_id')

        if all([surname, passport, address, birthday, ward_id, doc_id]):
            patient_info = add_patient(surname, passport, address, birthday, ward_id, doc_id)

    # Получаем список пациентов с возможностью сортировки
    sort_by = request.args.get('sort_by', 'receipt_date')
    patients_info = get_all_patients()
    patients = patients_info.result if patients_info.status else []
    print(patients)

    return render_template('patients_list.html',
                           patients=patients,
                           sort_by=sort_by)


@bp_patients.route('/discharge_patient', methods=['POST'])
def discharge_patient():
    patient_id = request.form.get('patient_id')
    if patient_id:
        result = discharge_patient(patient_id)

    return redirect(url_for('bp_patients.patients_menu'))