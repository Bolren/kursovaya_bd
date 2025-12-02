select distinct speciality, ward_num, reserved_wards, seats_sum, seats_taken
from department_workload_reports r
    join doctors d on r.dep_id = d.dep_id
    join department dep on r.dep_id = dep.dep_id
where report_year = (%s) and report_month = (%s)