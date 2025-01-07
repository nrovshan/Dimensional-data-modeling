-- 4. Backfill query for actors_history_scd: Write a "backfill" query that can populate 
-- the entire actors_history_scd table in a single query.

insert into actors_history_scd
with previous as(
      select actorid,
	         actor,
	         quality_class,
	         is_active,
	         current_season,
	         lag(quality_class, 1) over(partition by actor order by current_season ) as prev_q_class,
	         lag(is_active, 1) over(partition by actor order by current_season) as prev_activity
	  from actors 
	  where current_season <= 2022
),


  indicators as(
       select *,
	        case 
	           when prev_q_class <> quality_class then 1
	           when is_active <> prev_activity then 1
	        else 0
	        end as new_indicator
	    from previous  
),

   result_change as(
      select *, 
	         sum(new_indicator) over(partition by actor order by current_season) as final_result
	  from indicators
   ) 

select 
     actorid,
	 actor,
	 quality_class,
	 is_active,
	 min(current_season) as start_season,
	 max(current_season) as end_season,
	 2022 as current_season
from result_change
group by actorid, actor, final_result, quality_class, is_active
order by actorid, final_result;

select * from actors_history_scd;
