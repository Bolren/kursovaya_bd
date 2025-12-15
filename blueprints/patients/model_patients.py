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


def row_to_ward_dict(row):
    """Преобразует строку из БД в словарь с информацией о палате"""
    return {
        'ward_id': row[0],
        'index': row[1],
        'type': row[2],
        'seats_num': row[3],
        'speciality': row[4],
        'occupied': row[5],
        'ward_info': f"{row[4]} - палата №{row[1]} ({row[2]})"
    }


def get_available_wards():
    """Получает список свободных палат (не полностью занятых)"""
    err_message = ''
    _sql = sql_provider.get('available_wards.sql')
    rows = select_dict(_sql, {})

    if rows:
        available_wards = [row_to_ward_dict(row) for row in rows]
        return ResultInfoPatient(available_wards, True, err_message)
    else:
        err_message = 'Свободные палаты не найдены'
        return ResultInfoPatient([], False, err_message)


def save_patients_to_db(patients_list):
    """Сохраняет список пациентов в БД"""
    err_message = ''

    if not patients_list:
        err_message = 'Нет пациентов для сохранения'
        return ResultInfoPatient([], False, err_message)

    try:
        with DBContextManager(current_app.config['db_config']) as cursor:
            saved_patients = []

            for patient in patients_list:
                # 1. Добавляем пациента в таблицу patients
                sql_patient = sql_provider.get('add_patient.sql')
                cursor.execute(sql_patient, {
                    'surname': patient['surname'],
                    'passport': patient['passport'],
                    'address': patient['address'],
                    'birthday': patient['birthday'],
                    'ward_id': patient['ward_id'],
                    'doc_id': None  # По умолчанию без врача
                })
                patient_id = cursor.lastrowid

                # 2. Добавляем запись в medical_history
                sql_history = sql_provider.get('add_medical_history.sql')
                cursor.execute(sql_history, {
                    'patient_id': patient_id,
                    'diagnosis': patient['diagnosis'],
                    'receipt_date': date.today()
                })

                saved_patients.append({
                    'patient_id': patient_id,
                    'surname': patient['surname']
                })

            return ResultInfoPatient(saved_patients, True, err_message)

    except Exception as e:
        err_message = f'Ошибка при сохранении пациентов в БД: {str(e)}'
        return ResultInfoPatient([], False, err_message)