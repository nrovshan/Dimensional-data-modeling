-- 2. Cumulative table generation query: Write a query that populates the actors table one year at a time.

insert into actors
with yearss as(
select * from generate_series(1970, 2022) as year
),

    actors as(
	     select actorid, actor, min(year) as first_year
		 from actor_films 
		 group by actorid, actor
),

   actors_and_years as(
        select * from actors a
	    join yearss y on a.first_year <= y.year
),
   windowed as(
        select distinct
	         ay.actorid,
	         ay.year,
	         ay.actor,
	         array_remove(
	         array_agg(case 
		               when af.year is not null 
					   then cast(row(af.filmid, af.film, af.year, af.votes, af.rating) as films)
	                   end)
	         over (partition by ay.actor order by coalesce(af.year, ay.year)), null) as years 
	    from actors_and_years ay 
	    left join actor_films af
	    on ay.actorid = af.actorid 
	    and ay.year = af.year   
),

 statics as (
       select  
	         actorid,
	         max(actor) as actor
	   from actor_films af
	   group by actorid
 
 )
 
select 
     w.actorid,
	 s.actor,
	 years as films,
	 case 
	     when (years[cardinality(years)]).rating > 8 then 'star'
		 when (years[cardinality(years)]).rating > 7 then 'good'
		 when (years[cardinality(years)]).rating > 6 then 'average'
		 else 'bad' 
		 end::quality_class as quality_class,
	w.year as current_season,
	(years[cardinality(years)]).year = w.year as is_active
	
from windowed w
join statics s
on w.actorid = s.actorid;