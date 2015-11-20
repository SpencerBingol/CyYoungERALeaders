SELECT p.yearID, p.lgID,
	CAST((SUM(p.ER)*27.0)/SUM(p.IPOuts) as decimal(10,2)) as ERA,
	CAST(SUM(p.IPouts)+0.0/3 AS decimal(10,1)) as IP, 
	SUM(p.H) as H, 
	SUM(p.HR) as HR, 
	SUM(p.BB) as BB, 
	SUM(p.SO) as SO, 
	SUM(p.IBB) AS IBB, 
	SUM(p.WP) AS WP, 
	SUM(p.HBP) AS HBP, 
	SUM(p.BFP) AS BFP, 
	SUM(p.R) AS R, 
	SUM(p.SH) AS SH, 
	SUM(p.SF) AS SF 
FROM dbo.Pitching p
WHERE p.yearID >= 1967
GROUP BY p.yearID, p.lgID
UNION ALL
SELECT p.yearID, 'ML',
	CAST((SUM(p.ER)*27.0)/SUM(p.IPOuts) as decimal(10,2)) as ERA,
	CAST(SUM(p.IPouts)+0.0/3 AS decimal(10,1)) as IP, 
	SUM(p.H) as H, 
	SUM(p.HR) as HR, 
	SUM(p.BB) as BB, 
	SUM(p.SO) as SO, 
	SUM(p.IBB) AS IBB, 
	SUM(p.WP) AS WP, 
	SUM(p.HBP) AS HBP, 
	SUM(p.BFP) AS BFP, 
	SUM(p.R) AS R, 
	SUM(p.SH) AS SH, 
	SUM(p.SF) AS SF 
FROM dbo.Pitching p
WHERE p.yearID >= 1956 AND p.yearID < 1967
GROUP BY p.yearID
ORDER BY p.yearID DESC