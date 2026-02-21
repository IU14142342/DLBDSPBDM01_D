-- Durchschnittliche Bewertung pro Buch
CREATE OR REPLACE VIEW dm_vw_buch_rating AS
SELECT
  b.id,
  b.titel,
  AVG(r.bewertung)::NUMERIC(10,2) AS avg_rating,
  COUNT(*) AS anzahl_reviews
FROM public.buch b
JOIN public.rezension r ON r.buch_id = b.id
GROUP BY b.id, b.titel;
