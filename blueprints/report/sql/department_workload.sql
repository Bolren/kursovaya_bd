select distinct speciality, ward_num, reserved_wards, seats_taken
from department_workload_reports r
    join doctors d on r.dep_id = d.dep_id
    join department dep on r.dep_id = dep.dep_id
where r_year = (%s) and r_month = (%s)