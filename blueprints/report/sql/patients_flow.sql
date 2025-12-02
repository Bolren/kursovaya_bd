select admitted_sum, discharged_sum
from patients_flow_reports
where report_year = (%s) and report_month = (%s)