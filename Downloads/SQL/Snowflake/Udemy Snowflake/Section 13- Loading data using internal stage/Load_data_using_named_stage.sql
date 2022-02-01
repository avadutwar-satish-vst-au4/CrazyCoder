-- Load data using named stage.

 create or replace table emp_basic_named_stage (
         file_name string,
         fie_row_number string,
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);


create or replace stage my_int_stage

put file:///GITHUB/Snowflake/Snowflake/getting-started/employees0*.csv @sample_database.public.my_int_stage/emp;

TRUNCATE TABLE emp_basic_local;

copy into emp_basic_local
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @my_int_stage t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';


copy into emp_basic_named_stage
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @my_int_stage t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';
