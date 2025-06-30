-- highest_donation_assignments
WITH donation_amount AS (
	SELECT a.assignment_id,
		ROUND(SUM(d.amount),2) AS rounded_total_donation_amount,
		don.donor_type
	FROM assignments AS a
	LEFT JOIN donations AS d
	ON a.assignment_id = d.assignment_id
	LEFT JOIN donors AS don
	ON d.donor_id = don.donor_id
	WHERE don.donor_type IS NOT NULL
	GROUP BY a.assignment_id, don.donor_type
)
SELECT a.assignment_name,
	a.region,
	d.rounded_total_donation_amount,
	d.donor_type
FROM donation_amount as d
JOIN assignments as a 
ON a.assignment_id = d.assignment_id
ORDER BY rounded_total_donation_amount DESC
LIMIT 5;

-- top_regional_impact_assignments
WITH total_donations AS ( 
	SELECT a.assignment_id,
		a.assignment_name,
		region,
		a.impact_score,
		COUNT(d.donation_id) as num_total_donations
	FROM assignments AS a 
	LEFT JOIN donations AS d 
	ON a.assignment_id = d.assignment_id
	GROUP BY a.assignment_id
	),
rank_donations AS ( 
	SELECT assignment_id,
		region,
		impact_score,
		ROW_NUMBER() OVER(PARTITION BY region ORDER BY impact_score DESC) AS ranking
	FROM total_donations 
	)
SELECT t.assignment_name,
	t.region,
	t.impact_score,
	t.num_total_donations
FROM rank_donations as r 
LEFT JOIN total_donations as t
ON r.assignment_id = t.assignment_id
WHERE num_total_donations IS NOT NULL
	AND ranking = 1
ORDER BY t.region;
