BEGIN;

-- Soft Delete (empfohlen statt physischem Delete)
UPDATE public.buch SET is_active = FALSE WHERE buch_id = 1;

-- Erwartung: Buch taucht in Suche nicht mehr auf, Historie bleibt konsistent
ROLLBACK;