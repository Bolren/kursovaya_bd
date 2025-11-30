SELECT doc_id, surname, speciality, hiring_date
FROM doctors
WHERE YEAR(hiring_date) = (%s)
ORDER BY hiring_date;