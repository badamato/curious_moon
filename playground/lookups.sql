 -- what are my distinct values for...say, my to-be-created TEAMS table?
select distinct(team) as description
into teams -- here, I don't have a teams table yet but, I'm creating it on the fly!
from import.master_plan;

-- add a primary key
alter table teams
add id serial primary key;

-- do this for all my targeted lookup tables: team, spass_type, target, request_name, library_definition
-- template below:

drop table if exists <LOOKUP TABLE>;

select distinct(data_catagory) as description
into <LOOKUP TABLE>
from import.master_plan;

alter table <LOOKUP TABLE>
add id serial primary key;