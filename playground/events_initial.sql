-- normalizing - creating the events table

create table events(
  id serial primary key,
  time_stamp timestamptz not null,
  title varchar(500),
  description text,
  event_type_id int,
  spass_type_id int,
  target_id int,
  team_id int,
  request_id int
);

-- initial attempt to transfer of data from import schema data into my public table EVENTS
-- insert into events(time_stamp, title, description)
-- select
--   import.master_plan.date,
--   import.master_plan.title,
--   import.master_plan.description
-- from import.master_plan;

-- revised attempt to transfer of data from import schema data into my public table EVENTS
-- insert into events(time_stamp, title, description)
-- select
--   import.master_plan.date::timestamptz,
--   import.master_plan.title,
--   import.master_plan.description
-- from import.master_plan;

-- ran into a snag here because I get an error, psql can't determine what those Excel/csv formatted string dates are. I could have tested this first by running:

-- select date::timestamptz from import.master_plan;

-- or, even checking what psql is going to convert my timestamptz to - against my server's timezone - by running:
-- select '2000-01-01'::timestamptz;
-- -[ RECORD 1 ]-----------------------
-- timestamptz | 2000-01-01 00:00:00-05 <<------ this is saying that it is UTC+5, which is Eastern Time

-- final attempt to transfer of data from import schema data into my public table EVENTS
insert into events(time_stamp, title, description)
select
  import.master_plan.start_time_utc::timestamptz at time zone 'UTC',
  import.master_plan.title,
  import.master_plan.description
from import.master_plan;