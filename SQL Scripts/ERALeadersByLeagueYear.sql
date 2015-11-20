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
		GROUP BY playerID, yearID, lgID
		HAVING SUM(IPOuts) >= (162*3)
	) qual
) p
	ON m.playerID = p.playerID
WHERE row_num <= 5
ORDER BY yearID, lgID, row_num