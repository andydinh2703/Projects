-- What is the oldest business on each continent?
WITH old_busi AS (
	SELECT c.continent,
		c.country,
		b.business,
		b.year_founded,
		RANK() OVER(PARTITION BY c.continent ORDER BY year_founded) AS ranking
	FROM countries AS c
	JOIN businesses AS b 
	ON c.country_code = b.country_code
)
SELECT continent, country, business, year_founded
FROM old_busi
WHERE ranking = 1
ORDER BY year_founded;

-- How many countries per continent lack data on the oldest businesses
-- Does including the `new_businesses` data change this?
WITH all_businesses AS (
	SELECT *
	FROM businesses AS b
	UNION ALL
	SELECT * 
	FROM new_businesses AS n
),
business_cont AS (
	SELECT a.business, c.continent
	FROM countries AS c
	LEFT JOIN all_businesses AS a
	ON a.country_code = c.country_code
	WHERE a.business IS NULL
)
SELECT continent, COUNT(*) AS countries_without_businesses
FROM business_cont
GROUP BY continent;

-- Which business categories are best suited to last over the course of centuries?
WITH old_cont_cat AS (
	SELECT c.continent,
		ca.category,
		b.year_founded,
		RANK() OVER(PARTITION BY ca.category, c.continent ORDER BY b.year_founded) AS old_rank
	FROM businesses AS b
	JOIN countries AS c
	ON c.country_code = b.country_code
	JOIN categories AS ca
	ON b.category_code = ca.category_code
)
SELECT continent,
	category,
	year_founded
FROM old_cont_cat
WHERE old_rank = 1;
