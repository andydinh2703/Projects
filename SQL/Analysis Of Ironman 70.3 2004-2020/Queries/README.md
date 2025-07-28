## 1. What does a winning performance look like?
- I would like to show the total time completing the race for each winner, and the average time for each race accordingly.
```sql
--> Average total time 
CREATE VIEW avg_winning_time AS
	SELECT gender,
		age_band, 
		country,
		location_,
		total_time,
		avg_finish_time
	FROM all_winners
	WHERE ranking = 1;
```
<img width="788" height="288" alt="Screenshot 2025-07-28 at 11 34 13 AM" src="https://github.com/user-attachments/assets/56bb2d95-3cfd-4728-ac26-90ec2b98e21a" />

## 2. Which segments consume the most time in a typical winning race?
```sql
  --> Which segments consume the most time in a typical winning race?
CREATE VIEW winners_segments_time_percentage AS
	SELECT
		gender,
		age_band,
		country,
		location_,
		ROUND((swim_time::decimal/finish_time)* 100, 1) AS swim_percentage,
		ROUND((transition1_time::decimal/finish_time)* 100, 1) AS transition1_percentage,
		ROUND((bike_time::decimal/finish_time)*100, 1) AS bike_percentage,
		ROUND((transition2_time::decimal/finish_time)*100, 1) AS transition2_percentage,
		ROUND((run_time::decimal/finish_time)*100, 1) AS run_percentage
	FROM all_winners;
```
- When I just created this view, the percentage of transition2 and running was 0 for all records. Therefore, I double checked with chatGPT and found out that integer/integer will be round up to integer, so I tried to cast all activities’ times into decimal, and it worked perfectly. 
<img width="1330" height="287" alt="Screenshot 2025-07-28 at 11 35 25 AM" src="https://github.com/user-attachments/assets/2b97b2fa-430d-4f8a-bcc6-a1f566a4ab12" />

## 3. Which segment has the biggest impact on total race time?
- I created a new view based on the *ironman70_3_view*, calculating average segment time spending percentage for all athletes, then I join with the *winners_segments_time_percentage* view which I created above.
```sql
--> average segments time for each race location
CREATE VIEW segments_time_avg AS 
	SELECT location_,
		ROUND(AVG(swim_time::decimal/finish_time)* 100, 1) AS avg_swim_percentage,
		ROUND(AVG(transition1_time::decimal/finish_time)* 100, 1) AS avg_transition1_percentage,
		ROUND(AVG(bike_time::decimal/finish_time)*100, 1) AS avg_bike_percentage,
		ROUND(AVG(transition2_time::decimal/finish_time)*100, 1) AS avg_transition2_percentage,
		ROUND(AVG(run_time::decimal/finish_time)*100, 1) AS avg_run_percentage
	FROM ironman70_3_view
	GROUP BY location_;

--> Comparing winners with average segments time
SELECT w.gender,
	w.country,
	w.location_,
	w.swim_percentage,
	s.avg_swim_percentage,
	w.transition1_percentage,
	s.avg_transition1_percentage,
	w.bike_percentage,
	s.avg_bike_percentage,
	w.transition2_percentage,
	s.avg_transition2_percentage,
	w.run_percentage,
	s.avg_run_percentage
FROM winners_segments_time_percentage AS w
LEFT JOIN segments_time_avg as s
ON w.location_ = s.location_;
```
<img width="1309" height="261" alt="Screenshot 2025-07-28 at 11 39 38 AM" src="https://github.com/user-attachments/assets/8f8ce9a4-5e2b-4eb9-80b2-ebf27af0ee29" />

## 4. Will athletes who finish the swim first tend to win the race? 
```sql
--> How often do swim leaders also win the race? 
CREATE VIEW swim_leaders_winners AS
	WITH min_swim_time AS (
		SELECT *,
			MIN(swim_time) OVER(PARTITION BY location_ ORDER BY swim_time) AS min_swim
		FROM ironman70_3_view
	)
	SELECT gender,
			country,
			location_,
			event_year,
			swim_duration
	FROM min_swim_time
	WHERE swim_time = min_swim AND
		ranking = 1;
		
```
<img width="733" height="289" alt="Screenshot 2025-07-28 at 11 50 14 AM" src="https://github.com/user-attachments/assets/650d0003-6c19-4938-bac7-d3f819de9dbb" />

## 5. Will athletes who finish the bike first tend to win the race? 
```sql
--> How often do biking leaders also win the race? 
CREATE VIEW bike_leaders_winners AS
	WITH min_bike_time AS (
		SELECT *,
			MIN(bike_time) OVER(PARTITION BY location_ ORDER BY bike_time) AS min_bike
		FROM ironman70_3_view
	)
	SELECT gender,
			country,
			location_,
			event_year,
			bike_duration
	FROM min_bike_time
	WHERE bike_time = min_bike AND
		ranking = 1;
```
<img width="724" height="285" alt="Screenshot 2025-07-28 at 11 51 03 AM" src="https://github.com/user-attachments/assets/37ddcacb-80c4-4c94-b5f5-cfe8c79f73ab" />

## 6. How often does the fastest transition time belong to the winner?

```sql
--> How often does the fastest transition time belong to the winner? 
CREATE VIEW fastest_transition_winners AS
	WITH fastest_transition AS (
		SELECT *,
			MIN(transition1_time + transition2_time) OVER(PARTITION BY location_ ORDER BY transition1_time) AS total_transition_min
		FROM ironman70_3_view
	)
	SELECT gender,
		country,
		location_,
		event_year,
		TO_CHAR(make_interval(secs => (transition1_time + transition2_time)), 'HH24:MI:SS') AS total_transition
	FROM fastest_transition 
	WHERE (transition1_time + transition2_time = total_transition_min) AND
		ranking = 1;
```

<img width="770" height="286" alt="Screenshot 2025-07-28 at 11 51 39 AM" src="https://github.com/user-attachments/assets/44696cd0-cf5a-4004-8fd8-dcf89b8596b5" />
- I originally looked for both fastest transition1 and transition 2 time, however, it might not be appropriate to do that. Instead, I changed to compare to the fastest total transition time.
  
## 7. Does transition time actually make a difference in winning?

```sql
--> comparing winners' transition time with top 10 finishers' transition time
CREATE VIEW transition_difference AS 
	WITH top_10_finishers AS (
		SELECT *
		FROM ironman70_3_view
		WHERE ranking BETWEEN 1 AND 10
	),
	avg_top10 AS ( 
		SELECT 
			location_,
			event_year,
			TO_CHAR(make_interval(secs => AVG(transition1_time)), 'HH24:MI:SS') AS avg_transition1,
			TO_CHAR(make_interval(secs => AVG(transition2_time)), 'HH24:MI:SS') AS avg_transition2
		FROM top_10_finishers
		GROUP BY location_, event_year
		ORDER BY event_year
	)
	SELECT w.gender,
			w.country,
			a.event_year,
			a.location_,
			w.transition1_duration,
			a.avg_transition1,
			w.transition2_duration,
			a.avg_transition2
	FROM all_winners AS w
	LEFT JOIN avg_top10 AS a
	ON w.location_ = a.location_;
```
<img width="1172" height="285" alt="Screenshot 2025-07-28 at 11 53 17 AM" src="https://github.com/user-attachments/assets/c0bb2ee3-9bb9-4569-a888-aa908fe29eb1" />

## 8. Which country has the most winners? 
```sql
--> Which country has the most winners?
CREATE VIEW winning_countries AS 
	SELECT country, 
		COUNT(*) AS num_winners
	FROM all_winners
	GROUP BY country;
```
<img width="248" height="287" alt="Screenshot 2025-07-28 at 11 54 04 AM" src="https://github.com/user-attachments/assets/6f95ef5c-d0f1-4e0e-8785-9fcbef1f9cf9" />

