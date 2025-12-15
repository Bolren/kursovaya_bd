SELECT
    distinct w.ward_id,
    w.index_number,
    w.ward_type,
    w.seats_num,
    d.speciality,
    COALESCE(patient_count.occupied, 0) as occupied
FROM wards w
LEFT JOIN (
    SELECT
        p.ward_id,
        COUNT(DISTINCT p.patient_id) as occupied
    FROM patients p
    WHERE p.patient_id IN (
        SELECT patient_id
        FROM medical_history
        WHERE discharge_date IS NULL
    )
    GROUP BY p.ward_id
) patient_count ON w.ward_id = patient_count.ward_id
JOIN doctors d on w.dep_id = d.dep_id
WHERE COALESCE(patient_count.occupied, 0) < w.seats_num
ORDER BY w.index_number ASC