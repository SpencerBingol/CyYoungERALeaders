SELECT leaders.*
FROM (
	SELECT CONCAT(m.nameFirst, ' ', m.nameLast) AS Name
		, p.*
	FROM dbo.Master m
	INNER JOIN (
		SELECT ROW_NUMBER() OVER(PARTITION BY qual.yearID, qual.lgID ORDER BY qual.ERA) AS row_num,
			qual.*
		FROM (
			SELECT  playerID,
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
		) qual
	) p
		ON m.playerID = p.playerID
	WHERE row_num <= 1) leaders
LEFT OUTER JOIN (
	SELECT CONCAT(m.nameFirst, ' ', m.nameLast) AS Name, a.awardID, a.tie, p.*
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
) winners
	ON leaders.playerID=winners.playerID
	AND leaders.yearID = winners.yearID
	AND leaders.lgID = winners.lgID
WHERE winners.playerID IS NULL
ORDER BY leaders.yearID DESC