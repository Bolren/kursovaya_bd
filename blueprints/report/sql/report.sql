select prod_name, prod_num, prod_amount
from purch_report join product using(prod_id)
where r_year = (%s) and r_month = (%s)