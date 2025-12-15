SELECT
    w.ward_id,
    w.index_number,
    w.type,
    w.seats_num,
    d.speciality,
    COUNT(p.patient_id) as occupied
FROM wards w
LEFT JOIN patients p ON w.ward_id = p.ward_id
    AND p.patient_id IN (
        SELECT patient_id FROM medical_history
        WHERE discharge_date IS NULL
    )
JOIN doctors d ON w.dep_id = d.dep_id
GROUP BY w.ward_id, w.index_number, w.type, w.seats_num, d.speciality
HAVING COUNT(p.patient_id) < w.seats_num
ORDER BY d.speciality ASC