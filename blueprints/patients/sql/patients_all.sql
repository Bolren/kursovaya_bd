SELECT * FROM patients p
JOIN medical_history h ON p.patient_id = h.patient_id
WHERE discharge_date IS NULL