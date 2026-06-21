---Create External Table
 ----Format
 ----Source

 ----Format
 If not EXISTS (select * from sys.external_file_formats where name = 'my_csv_format')
 
 Create EXTERNAL FILE FORMAT my_csv_format
 with(
    FORMAT_TYPE =  DELIMITEDTEXT,
    FORMAT_OPTIONS(
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2
        )
)

----Source
If not EXISTS (select * from sys.external_data_sources where name = 'officedata_src')
CREATE EXTERNAL DATA SOURCE officedata_src
WITH(
    LOCATION = 'abfss://source@skpadls.dfs.core.windows.net/2026/OfficeDataProject.csv'
)



create schema staging

CREATE EXTERNAL TABLE staging.officedata
(
 employee_id int,
 employee_name VARCHAR(50),
 department VARCHAR(50),
 state VARCHAR(5),
 salary int,
 age int,
 bonus int
)WITH
(
 LOCATION = '/',
 DATA_SOURCE = officedata_src,
 FILE_FORMAT = my_csv_format
)

select * from staging.officedata

create schema dwh

create table dwh.officedata
WITH(
    CLUSTERED COLUMNSTORE index,
    DISTRIBUTION = ROUND_ROBIN
) as select * from staging.officedata


select * from dwh.officedata




