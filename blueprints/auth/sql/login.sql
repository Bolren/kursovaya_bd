select user_group, user_id, login
from internal_users
where login = (%s) and password = (%s)