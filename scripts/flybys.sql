select targets.description as target, time_stamp, title from events inner join targets on target_id=targets.id;

select targets.description as target, time_stamp, title from events inner join targets on target_id=targets.id where title like '%flyby%' or title like '%fly by%';

select targets.description as target, time_stamp, title from events inner join targets on target_id=targets.id where title ilike '%flyby%' or title ilike '%fly by%' order by time_stamp;

/* like = case sensitive, ilike = case insensitive */

-- This query is checking all titles that start with T and have one or more numbers following that end with the term “flyby.” I’m getting around the case sensitivity issue by using the ~* comparison operator, which tells Postgres this is a case-insensitive match operation.

-- this type of quote  will end after a return - no need for an ending charachter


select targets.description as target, time_stamp, title from events inner join targets on target_id=targets.id where title ~* '^T\d.*? flyby$';

select targets.description as target, time_stamp, title from events inner join targets on target_id=targets.id where title ~* '^T[A-Z0-9].*? flyby$' order by time_stamp;

/* utilizing Regex query strings */


select targets.description as target,
event_types.description as event,
time_stamp,
time_stamp::date as date,
title
from events
left join targets on target_id=targets.id
left join event_types on event_type_id=event_types.id
where title ilike '%flyby%'
or title ilike '%fly by%'
order by time_stamp;

select target, title, date from import.master_plan where start_time_utc::date = '2005-02-17' order by start_time_utc::date;


--restarting Cassini!

select targets.description as target,
events.time_stamp,
event_types.description as event
from events
inner join event_types on event_types.id = events.event_type_id
inner join targets on targets.id = events.target_id
where events.time_stamp::date = '2005-2-17'
order by events.time_stamp;


select targets.description as target,
events.time_stamp,
event_types.description as event
from events
inner join event_types on event_types.id = events.event_type_id
inner join targets on targets.id = events.target_id
where events.time_stamp::date = '2005-2-17'
and targets.description = 'enceladus'
order by events.time_stamp;

/* remember single quotes for strings */
-- also, casting the time_stamp to date will encompass the ENTIRE day


select * from targets where description = 'Enceladus';
=> id = 28

select targets.description as target,
events.time_stamp,
event_types.description as event
from events
inner join event_types on event_types.id = events.event_type_id
inner join targets on targets.id = events.target_id
where events.time_stamp::date = '2005-2-17'
and targets.id = 28
order by events.time_stamp;

-- slimming this query so that we eliminate the need for case sensitivity and becasue the ID (the primary key) is already indexed for faster return


--sargeable and non-sargeable queries (Search ARGument ABLE), optimizing for the query plan, potentially better leveraging the index (stop sequential scanning for large databases! good practice)

drop view if exists enceladus_events;

create view enceladus_events as 
  select events.time_stamp,
  events.time_stamp::date as date,
  event_types.description as event
  from events
  inner join event_types on event_types.id = events.event_type_id
  where target_id = 28
  order by events.time_stamp;

  --creating a view to hold this data so we don't have to keep typing. not sure this is the best method as this disappears when the session closes...

  --aliasing the date so that it's easier to type when we query (versus the full stamp itself)

select * from enceladus_events where date = '02/17/2005';



drop view if exists enceladus_events;

create view enceladus_events as
  select
  events.id,
  events.title,
  events.description,
  events.time_stamp,
  events.time_stamp::date as date,
  event_types.description as event
  from events
  inner join event_types on event_types.id = events.event_type_id
  where target_id = 28
  order by events.time_stamp;


-- this result too big so we changed display type to HTML and exported it to an html file

enceladus=# \H
Output format is html.
enceladus=# \o flybys.sql
enceladus=# \o '/Users/bethdamato/cassini/mymoon/copyof_flybys.html'
enceladus=# select id, time_stamp, title, description from enceladus_events where date='02/17/2005'::date;


--opening our searches wider to look for other descriptions (full text) that might contribute to how this moon could be causing one of Saturn's rings!

drop view if exists enceladus_events;
create view enceladus_events as
  select
  events.id,
  events.title,
  events.description,
  events.time_stamp,
  events.time_stamp::date as date,
  event_types.description as event,
  to_tsvector(events.description) as search
  from events
  inner join event_types on event_types.id = events.event_type_id
  where target_id = 28
  order by events.time_stamp;



select id, date, title
from enceladus_events
where date between '2005-02-01'::date and '2005-02-28'::date
and search @@ to_tsquery('thermal');


