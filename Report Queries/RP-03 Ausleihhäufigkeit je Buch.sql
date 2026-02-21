--Zustand Historie
SELECT z1.zustand AS vorher,
       z2.zustand AS nachher,
       COUNT(*) AS anzahl
FROM ausleihvorgang av
JOIN zustand z1 ON z1.id = av.zustand_vor_ausleih
JOIN zustand z2 ON z2.id = av.zustand_nach_ausleih
GROUP BY vorher, nachher;