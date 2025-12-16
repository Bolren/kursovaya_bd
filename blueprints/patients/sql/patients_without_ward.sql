SELECT
    distinct p.patient_id,
    p.surname,
    p.passport,
    p.address,
    p.birthday,
    mh.diagnosis,
    mh.receipt_date,
    d.surname,
    d.speciality
FROM patients p
JOIN medical_history mh ON p.patient_id = mh.patient_id
LEFT JOIN doctors d ON p.doc_id = d.doc_id
WHERE p.ward_id IS NULL
  AND mh.discharge_date IS NULL
ORDER BY mh.receipt_date ASC