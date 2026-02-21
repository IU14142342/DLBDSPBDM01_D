BEGIN;

-- Erwartung: Fehler wegen ck_ausleihvorgang_datum (von <= bis)
INSERT INTO public.ausleihvorgang
(buch_id, benutzer_id, von, bis, lieferart_id, zustand_vor_ausleih)
VALUES
(1, 1, DATE '2026-02-10', DATE '2026-02-01', 1, 1);

ROLLBACK;