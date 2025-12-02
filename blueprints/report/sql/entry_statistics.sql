select surname, entry_amount
from entry_statistics_reports r
    join doctors d on r.doc_id = d.doc_id
where report_year = (%s) and report_month = (%s)