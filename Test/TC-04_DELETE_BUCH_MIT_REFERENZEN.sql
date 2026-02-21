BEGIN;

-- Annahme: buch_id=1 existiert und wird referenziert (ausleihvorgang / rezension)
-- Erwartung: DELETE schlägt fehl, wenn FK ON DELETE RESTRICT/NO ACTION gesetzt ist
DELETE FROM public.buch WHERE id = 1;

ROLLBACK;