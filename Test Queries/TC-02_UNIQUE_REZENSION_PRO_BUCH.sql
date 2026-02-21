BEGIN;

-- Erwartung: 1. Insert ok, 2. Insert fail wegen UNIQUE (benutzer_id, buch_id)
INSERT INTO public.rezension (benutzer_id, buch_id, bewertung, kommentar)
VALUES (1, 1, 5, 'Top');

INSERT INTO public.rezension (benutzer_id, buch_id, bewertung, kommentar)
VALUES (1, 1, 4, 'Zweites Review');

ROLLBACK;