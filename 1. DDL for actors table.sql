-- 1. DDL for actors table: Create a DDL for an actors table.

create type films as(
         filmid text,
	     film text,
	     year integer,
	     votes integer,
	     rating real	 
);

create type quality_class as enum('star','good','average','bad');

create table actors(
          actorid text,
	      actor text,
	      films films[],
	      quality_class quality_class,
	      current_season integer,
	      is_active boolean,
	      primary key(actorid, current_season)
);












