SELECT e.entry_date, e.note, p.surname
FROM history_entries e
JOIN medical_history m on m.history_id = e.history_id
JOIN patients p ON m.patient_id = p.patient_id
JOIN doctors d ON e.doc_id = d.doc_id
WHERE d.surname = (%s)
ORDER BY e.entry_date DESC;