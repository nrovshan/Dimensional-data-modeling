-- 5. Incremental query for actors_history_scd

create type actorscd_type as(
         quality_class quality_class,
	     is_active boolean,
	     start_season integer,
	     end_season integer
);

with the_last_year as(
      select *
	  from actors_history_scd
	  where current_season = 2022
	  and end_season = 2022
),

 historical_year as(
      select 
	     actorid,
	     actor,
	     quality_class,
	     is_active,
	     start_season,
	     end_season
	  from actors_history_scd
	  where current_season = 2022
	  and end_season < 2022
   
   ),
   
 this_year as(
      select *
	  from actors_history_scd
	  where current_season = 2023 
   ),
   
 same_records as(
       select ty.actorid,
	          ty.actor,
			  ty.quality_class,
			  ty.is_active,
			  tly.start_season,
			  ty.current_season as end_season
	   from this_year ty
	   join the_last_year tly 
	   on ty.actorid = tly.actorid
	   where ty.quality_class = tly.quality_class
	   and ty.is_active = tly.is_active
 ),
 
 changed_records as(
        select ty.actorid,
	           ty.actor,
	           unnest(
				   array[
					   row(ty.quality_class,
	                       ty.is_active,
	                       ty.start_season,
	                       ty.end_season)::actorscd_type,
					   row(tly.quality_class,
	                       tly.is_active,
	                       tly.start_season,
	                       tly.end_season)::actorscd_type
				   ] ) as arrays
	    from this_year ty
	    join the_last_year tly 
	    on ty.actorid = tly.actorid
	    where ty.quality_class <> tly.quality_class
	   or ty.is_active <> tly.is_active
 
 ),
 
 unnested_changed_records as(
      select 
	      actorid,
	      actor,
	      (arrays::actorscd_type).quality_class,
	      (arrays::actorscd_type).is_active,
	      (arrays::actorscd_type).start_season,
	      (arrays::actorscd_type).end_season
	  from changed_records 
 ),
 
 new_records as (
       select
	          ty.actorid,
	          ty.actor,
			  ty.quality_class,
			  ty.is_active,
			  tly.current_season as start_season,
			  ty.current_season as end_season
	 from this_year ty
	   join the_last_year tly 
	   on ty.actorid = tly.actorid
	   where tly.actorid is null
 )
 


select * from historical_year

union all

select * from same_records

union all

select * from unnested_changed_records

union all 

select * from new_records;
