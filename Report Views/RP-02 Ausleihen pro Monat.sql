--Ausleihen pro Monat
SELECT date_trunc('month', von) AS monat, COUNT(*) 
FROM ausleihvorgang
GROUP BY monat
ORDER BY monat;