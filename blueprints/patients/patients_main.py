import os
from flask import Blueprint, render_template, request, redirect, url_for, session, current_app
from database.sql_provider import SQLProvider
from blueprints.patients.model_patients import get_available_wards, save_patients_to_db

bp_patients = Blueprint(
    'bp_patients',
    __name__,
    template_folder='templates')

sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@bp_patients.route('/patients', methods=['GET', 'POST'])
def patients_menu():
    # Инициализируем сессию для пациентов, если ее нет
    if 'patients_session' not in session:
        session['patients_session'] = []

    # Получаем список свободных палат
    wards_result = get_available_wards()
    available_wards = wards_result.result if wards_result.status else []

    if request.method == 'POST':
        # Определяем какая кнопка была нажата
        if 'add_patient' in request.form:
            # Добавление пациента в сессию
            surname = request.form.get('surname')
            passport = request.form.get('passport')
            address = request.form.get('address')
            birthday = request.form.get('birthday')
            diagnosis = request.form.get('diagnosis')
            ward_id = request.form.get('ward_id')

            if all([surname, passport, address, birthday, diagnosis, ward_id]):
                # Проверяем, нет ли уже пациента с таким паспортом в сессии
                existing_patient = next(
                    (p for p in session['patients_session'] if p['passport'] == passport),
                    None
                )

                if not existing_patient:
                    # Находим информацию о выбранной палате
                    selected_ward = next((w for w in available_wards if str(w['ward_id']) == ward_id), None)

                    new_patient = {
                        'surname': surname,
                        'passport': passport,
                        'address': address,
                        'birthday': birthday,
                        'diagnosis': diagnosis,
                        'ward_id': int(ward_id),
                        'ward_info': selected_ward['ward_info'] if selected_ward else f"Палата {ward_id}",
                        'session_id': len(session['patients_session']) + 1
                    }
                    session['patients_session'].append(new_patient)
                    session.modified = True

        elif 'save_all' in request.form:
            # Сохранение всех пациентов из сессии в БД
            session_patients = session.get('patients_session', [])

            if session_patients:
                # Сохраняем всех пациентов в БД
                save_result = save_patients_to_db(session_patients)

                if save_result.status:
                    # Очищаем сессию после успешного сохранения
                    session['patients_session'] = []
                    session.modified = True
                    # Сохраняем сообщение об успехе
                    session['save_message'] = f"Успешно сохранено {len(session_patients)} пациентов"
                else:
                    # Сохраняем сообщение об ошибке
                    session['save_message'] = f"Ошибка при сохранении: {save_result.err_message}"

        elif 'clear_session' in request.form:
            # Очистка сессии
            session['patients_session'] = []
            session.modified = True

    # Получаем пациентов из сессии
    session_patients = session.get('patients_session', [])

    # Получаем сообщение о сохранении (если есть) и удаляем его из сессии
    save_message = session.pop('save_message', None)

    return render_template('patients_list.html',
                           session_patients=session_patients,
                           available_wards=available_wards,
                           save_message=save_message)


@bp_patients.route('/remove_from_session', methods=['POST'])
def remove_from_session():
    session_id = request.form.get('session_id')
    if session_id:
        # Удаляем пациента из сессии
        session_patients = session.get('patients_session', [])
        session['patients_session'] = [p for p in session_patients
                                       if p['session_id'] != int(session_id)]
        session.modified = True

    return redirect(url_for('bp_patients.patients_menu'))