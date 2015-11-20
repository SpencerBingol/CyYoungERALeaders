SELECT CONCAT(m.nameFirst, ' ', m.nameLast) AS Name, a.awardID, a.tie, a.lgID, p.*
FROM dbo.AwardsPlayers a
INNER JOIN (
	 SELECT playerID,
		yearID,
		lgID,
		CAST((SUM(ER)*27.0)/SUM(IPOuts) as decimal(10,2)) as ERA,
		CAST((SUM(IPouts)+0.0)/3 AS decimal(10,1)) as IP, 
		SUM(H) as H, 
		SUM(HR) as HR, 
		SUM(BB) as BB, 
		SUM(SO) as SO, 
		SUM(IBB) AS IBB, 
		SUM(WP) AS WP, 
		SUM(HBP) AS HBP, 
		SUM(BFP) AS BFP, 
		SUM(R) AS R, 
		SUM(SH) AS SH, 
		SUM(SF) AS SF 
	FROM dbo.Pitching
	WHERE yearID >= 1967
	GROUP BY playerID, yearID, lgID
	HAVING SUM(IPOuts) >= (162*3)
) p
	ON a.playerID = p.playerID
	AND a.yearID = p.yearID
INNER JOIN dbo.Master m
	ON a.playerID = m.playerID
WHERE awardID = 'Cy Young Award'
	AND a.lgID <> 'ML'
ORDER BY a.yearID, a.lgID DESC