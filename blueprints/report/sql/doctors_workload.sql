select doc_id, surname, patient_amount
from doctors_workload_reports r
    join doctors d on r.doc_id = d.doc_id
where r_year = (%s) and r_month = (%s)