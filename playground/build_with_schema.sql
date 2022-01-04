/* initial attempt*/

-- drop table if exists master_plan;

-- create table master_plan(
--   start_time_utc text,
--   duration text,
--   date text,
--   team text,
--   spass_type text,
--   target text,
--   request_name text,
--   library_definition text,
--   title text,
--   description text
-- );

-- COPY master_plan
-- FROM '/Users/bethdamato/cassini/curious_data/data/master_plan.csv' WITH DELIMITER ',' HEADER CSV;


/* adjusted original script to create a 'staging' schema to build and dump my raw
data on - I will called this schema, IMPORT */

create schema if not exists import;

drop table if exists import.master_plan;

create table import.master_plan(
  start_time_utc text,
  duration text,
  date text,
  team text,
  spass_type text,
  target text,
  request_name text,
  library_definition text,
  title text,
  description text
);

COPY import.master_plan
FROM '/Users/bethdamato/cassini/curious_data/data/master_plan.csv' WITH DELIMITER ',' HEADER CSV;