select distinct speciality, admitted_sum, discharged_sum
from patients_flow_reports r
    join department d on r.dep_id = d.dep_id
    join doctors doc on r.dep_id = doc.dep_id
where r_year = (%s) and r_month = (%s)