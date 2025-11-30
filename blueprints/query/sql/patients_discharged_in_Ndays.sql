SELECT p.surname, p.passport, m.receipt_date, m.discharge_date, w.index
FROM patients p
JOIN medical_history m ON p.patient_id = m.patient_id
JOIN wards w ON p.ward_id = w.ward_id
WHERE m.discharge_date >= DATE_SUB(CURRENT_DATE, INTERVAL (%s) DAY)
ORDER BY m.discharge_date DESC;