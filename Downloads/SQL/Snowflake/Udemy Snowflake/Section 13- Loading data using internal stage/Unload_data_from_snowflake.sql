-- Unload data

SELECT * FROM emp_basic_local

copy into @%emp_basic_local
from emp_basic_local
file_format = (type = csv field_optionally_enclosed_by='"')
--on_error = 'skip_file';

get @sample_database.public.%emp_basic_local file:///GITHUB/Snowflake/Snowflake/unload/
