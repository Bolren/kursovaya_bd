SELECT doc_id, surname, speciality, hiring_date
FROM doctors
WHERE hiring_date >= DATE_SUB(CURRENT_DATE, INTERVAL (%s) YEAR)
ORDER BY hiring_date;