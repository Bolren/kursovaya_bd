import os
from dataclasses import dataclass
from datetime import date

from flask import current_app
from database.DBcm import DBContextManager
from database.select import select_dict
from database.sql_provider import SQLProvider


@dataclass
class ResultInfoPatient:
    result: dict
    status: bool
    err_message: str


sql_provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


def row_to_patient_dict(row):
    return {
        'patient_id': row[0],
        'surname': row[1],
        'passport': row[2],
        'address': row[3],
        'birthday': row[4],
        'ward_id': row[5],
        'doc_id': row[6],
        'history_id': row[7],
        'diagnosis': row[8],
        'receipt_date': row[9],
        'discharge_date': row[10]
    }


def get_all_patients():
    err_message = ''
    _sql = sql_provider.get('patients_all.sql')
    rows = select_dict(_sql, {})

    # Фильтруем только активных пациентов (без даты выписки)
    active_patients = []
    for row in rows:
        patient = row_to_patient_dict(row)
        if patient['discharge_date'] is None:  # Только пациенты в госпитале
            active_patients.append(patient)

    if active_patients:
        return ResultInfoPatient(active_patients, True, err_message)
    else:
        err_message = 'Пациенты не найдены'
        return ResultInfoPatient([], False, err_message)


def get_patient_by_id(patient_id: int):
    err_message = ''
    _sql = sql_provider.get('patient_by_id.sql')
    rows = select_dict(_sql, {'patient_id': patient_id})

    if rows:
        patient = row_to_patient_dict(rows[0])
        return ResultInfoPatient(patient, True, err_message)
    else:
        err_message = 'Пациент не найден'
        return ResultInfoPatient({}, False, err_message)


def add_patient(surname, passport, address, birthday, ward_id, doc_id):
    err_message = ''
    _sql = sql_provider.get('add_patient.sql')

    try:
        with DBContextManager(current_app.config['db_config']) as cursor:
            cursor.execute(_sql, {
                'surname': surname,
                'passport': passport,
                'address': address,
                'birthday': birthday,
                'ward_id': ward_id,
                'doc_id': doc_id
            })
            patient_id = cursor.lastrowid

        # Получаем добавленного пациента
        return get_patient_by_id(patient_id)
    except Exception as e:
        err_message = f'Ошибка при добавлении пациента: {str(e)}'
        return ResultInfoPatient({}, False, err_message)


def discharge_patient(patient_id: int):
    err_message = ''
    _sql = sql_provider.get('discharge_patient.sql')

    try:
        with DBContextManager(current_app.config['db_config']) as cursor:
            cursor.execute(_sql, {'patient_id': patient_id})
            return ResultInfoPatient({'patient_id': patient_id}, True, err_message)
    except Exception as e:
        err_message = f'Ошибка при выписке пациента: {str(e)}'
        return ResultInfoPatient({}, False, err_message)