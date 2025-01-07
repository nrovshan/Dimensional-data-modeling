# Dimensional-data-modeling

The first section of this project is designed to leverage SCD and incremental updates for creating an efficient and scalable system capable of maintaining historical records.

By integrating Slowly Changing Dimensions (SCD), these queries ensure that data about actors evolves over time without losing previous information, enabling rich historical analysis.

 It achieves this by tracking and recording detailed information about actors' films, their performance (ratings), activity status, and career evolution over multiple years or seasons.

Actors Table Creation and Type Definitions
I created two custom types ‘films and quality_class’ and a table actors that stores information about actors and their films.
films is an array that holds film details like film ID, title, year, votes, and rating.
quality_class is an enum that categorizes actors based on the average rating of their films into "star," "good," "average," or "bad."

Populating the Actors Table Using Window Functions
This is to track films released by each actor and their quality over the years. It also keeps track of whether the actor was active in a given season.
Actors History SCD (Slowly Changing Dimension)
This query creates a table actors_history_scd to keep track of changes in the actor's quality classification and activity status over time. 
Populating the Actors History SCD Table
This query populates the actors_history_scd table by calculating changes in an actor's quality classification (quality_class) and activity status (is_active).
Incremental SCD for Actor Changes
This query performs an incremental load of the Slowly Changing Dimension (SCD) data for the actors. It compares the 2023 data with 2022 data and identifies:
Historical records (actors who did not change).
Same records (actors whose classification and activity remained unchanged).
Changed records (actors whose classification or activity changed).
New records (actors who were added in the current year).
