select user_group, user_id
from internal_users
where login = (%s) and password = (%s)