CREATE OR REPLACE VIEW public.dm_vw_ausleihen AS
SELECT
  av.id AS ausleihvorgang_id,
  av.von,
  av.bis,
  av.rueckgabe_am,
  (av.bis - av.von + 1) AS geplante_tage,
  (av.rueckgabe_am IS NULL) AS ist_offen,

  b.id AS buch_id,
  b.titel,
  g.genre AS genre,
  s.sprache AS sprache,
  st.status AS buch_status,
  z1.zustand AS zustand_vor,
  z2.zustand AS zustand_nach,

  u.id AS entleiher_id,
  concat_ws(' ', u.vorname, u.nachname) AS entleiher_name,
  l.bezeichnung AS lieferart

FROM public.ausleihvorgang av
JOIN public.buch b          ON b.id = av.buch_id
LEFT JOIN public.genre g    ON g.id = b.genre_id
LEFT JOIN public.sprache s  ON s.id = b.sprache_id
LEFT JOIN public.status st  ON st.id = b.status_id
LEFT JOIN public.zustand z1 ON z1.id = av.zustand_vor_ausleih
LEFT JOIN public.zustand z2 ON z2.id = av.zustand_nach_ausleih
JOIN public.benutzer u      ON u.id = av.benutzer_id
JOIN public.lieferart l     ON l.id = av.lieferart_id;