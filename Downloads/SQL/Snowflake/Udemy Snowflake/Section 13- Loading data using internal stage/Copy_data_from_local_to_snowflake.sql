-- Load data to table scene 1

create or replace table demo_db.public.emp_basic_1 (
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);

put file:///GITHUB/Snowflake/Snowflake/getting-started/employees0*.csv @demo_db.public.%emp_basic_1;

select * from demo_db.public.emp_basic_1

copy into demo_db.public.emp_basic_1
from @demo_db.public.%emp_basic_1
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';



-- Load data to table sence 2

create or replace table demo_db.public.emp_basic_2 (
         first_name string ,
         last_name string ,
         email string 
);

put file:///GITHUB/Snowflake/Snowflake/getting-started/employees0*.csv @demo_db.public.%emp_basic_2;

copy into demo_db.public.emp_basic_2
from (select  t.$1 , t.$2 , t.$3 from @demo_db.public.%emp_basic_2 t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';

select * from demo_db.public.emp_basic_2 

-- Loading data scene 3

# Create staging area.

create or replace table demo_db.public.emp_basic_local (
         file_name string,
         fie_row_number string,
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);


# Upload data to stagig area.

put file:///GITHUB/Snowflake/Snowflake/getting-started/employees0*.csv @demo_db.public.%emp_basic_local;

# Copy data from staging area to snowflake.

copy into demo_db.public.emp_basic_local
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @demo_db.public.%emp_basic_local t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';


select * from demo_db.public.emp_basic_local;

select split_part(file_name,'/',2) from demo_db.public.emp_basic_local;

/***************************************************************************/


-- Unload data scene 1

SELECT * FROM demo_db.public.emp_basic_local

copy into @demo_db.public.%emp_basic_local
from demo_db.public.emp_basic_local
file_format = (type = csv field_optionally_enclosed_by='"')
--on_error = 'skip_file';

get @demo_db.public.%emp_basic_local file:///GITHUB/Snowflake/Snowflake/unload/

-- Unload data scene 2

copy into @demo_db.public.%emp_basic_local/unload/test_
from (select first_name, last_name,email from demo_db.public.emp_basic_local)
file_format = (type = csv field_optionally_enclosed_by='"')
OVERWRITE=TRUE
--on_error = 'skip_file';


-- Load data using named stage.

 create or replace table demo_db.public.emp_basic_named_stage 
 (
         file_name string,
         fie_row_number string,
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);


create or replace stage control_db.internal_stages.my_int_stage

put file:///GITHUB/Snowflake/Snowflake/getting-started/employees0*.csv @control_db.internal_stages.my_int_stage/emp_basic_local;

TRUNCATE TABLE demo_db.public.emp_basic_local;

copy into demo_db.public.emp_basic_local
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @control_db.internal_stages.my_int_stage/emp_basic_local t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';

TRUNCATE TABLE demo_db.public.emp_basic_named_stage;

copy into demo_db.public.emp_basic_named_stage
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @control_db.internal_stages.my_int_stage/emp_basic_local t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';

select * from demo_db.public.emp_basic_named_stage;


