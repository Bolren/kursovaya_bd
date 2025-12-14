UPDATE medical_history
SET discharge_date = CURRENT_DATE
WHERE patient_id = :patient_id AND discharge_date IS NULL