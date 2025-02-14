-- Database Creation (PGAdmin)

CREATE TABLE "movies"(
    "id" INTEGER NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "genre" VARCHAR(255) NULL,
    "rel_date" DATE NULL,
    "rel_date1" DATE NULL,
    "metascore" NUMERIC NULL,
    "userscore" NUMERIC NULL,
    "world_wide_boxoffice" NUMERIC NULL,
    "award" VARCHAR(255) NULL
);

SELECT
id,
title,
genre,
coalesce (rel_date,rel_date1) AS rel_date,
award,
metascore,
userscore,
world_wide_boxoffice
INTO movies2
FROM movies;

DROP TABLE movies;

ALTER TABLE movies2
rename TO movies;


CREATE TABLE "genres"(
    "g_id" INTEGER NOT NULL,
    "g_name" VARCHAR(255) NOT NULL
);
CREATE TABLE "movies_genres"(
    "movie_id" INTEGER NOT NULL,
    "g_id" INTEGER NOT NULL
);
CREATE TABLE "awards"(
    "id" INTEGER NOT NULL,
    "a_name" VARCHAR(255) NULL
);
CREATE TABLE "movies_awards"(
    "id" INTEGER NOT NULL,
    "movie_id" INTEGER NOT NULL,
    "a_id" INTEGER NOT NULL
);
ALTER TABLE
    "movies" ADD PRIMARY KEY("id");
ALTER TABLE
    "genres" ADD PRIMARY KEY("g_id");
ALTER TABLE
    "awards" ADD PRIMARY KEY("id");
ALTER TABLE
    "movies_awards" ADD PRIMARY KEY("id");
    
ALTER TABLE
    "movies_genres" ADD CONSTRAINT "movies_genres_movie_id_foreign" FOREIGN KEY("movie_id") REFERENCES "movies"("id");
ALTER TABLE
    "movies_genres" ADD CONSTRAINT "movies_genres_genre_id_foreign" FOREIGN KEY("g_id") REFERENCES "genres"("g_id");


-- PGAdmin Queries

-- Sub-Question 1
-- calculate avg box office where award is NOT null
select count(g.id) as "awards given",avg(c.world_wide_boxoffice) as "avg_boxoffice"
from movies c
left join movies_awards g
on c.id = g.movie_id
where c.world_wide_boxoffice is not null

union

select count(g.id) as "awards given",avg(c.world_wide_boxoffice) as "avg_boxoffice"
from movies c
left join movies_awards g
on c.id = g.movie_id
where c.world_wide_boxoffice is null
;

-- Sub-Question  2
select
metascore, 
userscore,
award
from movies
where metascore is not null
group by metascore, userscore, award
order by metascore desc
;

-- Sub-Question  3
select e.g_name, 
count(c.award) AS "awards given"
from movies c
left join movies_genres d 
on c.id = d.movie_id
left join genres e
on d.g_id = e.g_id
group by e.g_name
order by "awards given" desc
;

-- Sub-Question 4
select
count(c.id) as "awards given",
extract(quarter from rel_date) as "quarter of Y"
from movies a
left join movies_awards c
on a.id = c.movie_id
where a.rel_date is not null and a.award is not null
group by "quarter of Y"
order by "awards given" desc
;
ALTER TABLE
    "movies_awards" ADD CONSTRAINT "movies_awards1" FOREIGN KEY("movie_id") REFERENCES "movies"("id");
ALTER TABLE
    "movies_awards" ADD CONSTRAINT "movies_awards2" FOREIGN KEY("a_id") REFERENCES "awards"("id");
