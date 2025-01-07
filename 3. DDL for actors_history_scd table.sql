-- DDL for actors_history_scd table

create table actors_history_scd(
               actorid text,
	           actor text,
               quality_class quality_class,
               is_active boolean,
               start_season integer,
               end_season integer,
               current_season integer,
	           primary key(actorid, start_season)
);