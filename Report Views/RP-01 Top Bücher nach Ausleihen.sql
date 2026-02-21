--Top Bücher
SELECT titel, COUNT(*) AS ausleihen
FROM dm_vw_ausleihen
GROUP BY titel
ORDER BY ausleihen DESC;