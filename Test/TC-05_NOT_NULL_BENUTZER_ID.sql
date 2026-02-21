BEGIN;

-- Erwartung: Fehler (entleiher_id NOT NULL)
INSERT INTO public.ausleihvorgang
(buch_id, benutzer_id, von, bis, lieferart_id, zustand_vor_ausleih)
VALUES
(1, NULL, DATE '2026-02-01', DATE '2026-02-10', 1, 1);

ROLLBACK;