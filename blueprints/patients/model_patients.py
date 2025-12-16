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
    """Преобразует строку из БД в словарь с информацией о пациенте"""
    return {
        'patient_id': row[0],
        'surname': row[1],
        'passport': row[2],
        'address': row[3],
        'birthday': row[4],
        'diagnosis': row[5],
        'receipt_date': row[6],
        'doctor': row[7],
        'speciality': row[8]
    }


def row_to_ward_dict(row):
    """Преобразует строку из БД в словарь с информацией о палате"""
    return {
        'ward_id': row[0],
        'index': row[1],
        'type': row[2],
        'seats_num': row[3],
        'dep_id': row[4],
        'occupied': row[5] if row[5] is not None else 0,
        'ward_info': f"{row[4]} - Палата №{row[1]} ({row[2]})"
    }


def get_patients_without_ward():
    """Получает список пациентов без назначенной палаты"""
    err_message = ''
    _sql = sql_provider.get('patients_without_ward.sql')
    rows = select_dict(_sql, {})

    if rows:
        patients = [row_to_patient_dict(row) for row in rows]
        return ResultInfoPatient(patients, True, err_message)
    else:
        err_message = 'Нет пациентов без назначенной палаты'
        return ResultInfoPatient([], True, err_message)


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


def assign_ward_to_patient(patient_id, ward_id):
    """Назначает палату пациенту"""
    err_message = ''

    try:
        with DBContextManager(current_app.config['db_config']) as cursor:
            sql = sql_provider.get('assign_ward.sql')
            cursor.execute(sql, (ward_id, patient_id))

            return ResultInfoPatient({
                'patient_id': patient_id,
                'ward_id': ward_id
            }, True, err_message)

    except Exception as e:
        err_message = f'Ошибка при назначении палаты: {str(e)}'
        return ResultInfoPatient({}, False, err_message)