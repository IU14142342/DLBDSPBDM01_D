--
-- PostgreSQL database dump
--

\restrict QG3y4nzjz5eYXM37SiMkCaAonI4i4OOWpVohvJMdxQwUws4gMSdA9Vd142PvcWi

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: abholort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abholort (
    id bigint NOT NULL,
    adresse character varying(255) NOT NULL,
    ort_id bigint NOT NULL
);


ALTER TABLE public.abholort OWNER TO postgres;

--
-- Name: TABLE abholort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.abholort IS 'Konkrete Abholstellen; referenziert Ort.';


--
-- Name: abholort_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.abholort ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.abholort_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ausleihdauer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ausleihdauer (
    id bigint NOT NULL,
    tage integer NOT NULL,
    bezeichnung character varying(80),
    CONSTRAINT ck_ausleihdauer_tage CHECK ((tage > 0))
);


ALTER TABLE public.ausleihdauer OWNER TO postgres;

--
-- Name: TABLE ausleihdauer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ausleihdauer IS 'Stammdaten für Leihzeitraeume (in Tagen) zur Standardisierung.';


--
-- Name: ausleihdauer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ausleihdauer ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ausleihdauer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ausleihvorgang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ausleihvorgang (
    id bigint NOT NULL,
    benutzer_id bigint NOT NULL,
    buch_id bigint NOT NULL,
    zustand_vor_ausleih bigint NOT NULL,
    zustand_nach_ausleih bigint,
    von date NOT NULL,
    bis date NOT NULL,
    lieferart_id bigint NOT NULL,
    rueckgabe_am date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_av_datum CHECK ((bis >= von)),
    CONSTRAINT ck_av_rueckgabe CHECK (((rueckgabe_am IS NULL) OR (rueckgabe_am >= von)))
);


ALTER TABLE public.ausleihvorgang OWNER TO postgres;

--
-- Name: TABLE ausleihvorgang; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ausleihvorgang IS 'Historisiert Ausleihen inkl. Zeitraum, Lieferart sowie Zustand vor/nach Ausleihe.';


--
-- Name: COLUMN ausleihvorgang.rueckgabe_am; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ausleihvorgang.rueckgabe_am IS 'NULL = Ausleihe offen; gesetzt = Rueckgabe erfolgt.';


--
-- Name: COLUMN ausleihvorgang.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ausleihvorgang.created_at IS 'Zeitstempel der Anlage zur Auditierbarkeit.';


--
-- Name: ausleihvorgang_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ausleihvorgang ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ausleihvorgang_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: autor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autor (
    id bigint NOT NULL,
    vorname character varying(120) NOT NULL,
    nachname character varying(120) NOT NULL
);


ALTER TABLE public.autor OWNER TO postgres;

--
-- Name: TABLE autor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.autor IS 'Stammdaten fuer Autoren; wird von buch referenziert.';


--
-- Name: autor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.autor ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.autor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: benutzer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.benutzer (
    id bigint NOT NULL,
    vorname character varying(120) NOT NULL,
    nachname character varying(120) NOT NULL,
    email character varying(255) NOT NULL,
    passwort character varying(255) NOT NULL,
    adresse character varying(255),
    ort_id bigint NOT NULL,
    benutzerrolle_id bigint NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.benutzer OWNER TO postgres;

--
-- Name: TABLE benutzer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.benutzer IS 'Speichert registrierte Nutzer inkl. Rolle und Ort -  Soft-Delete-Mechanismus is_active.';


--
-- Name: COLUMN benutzer.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.benutzer.is_active IS 'Soft-Delete: TRUE aktiv, FALSE deaktiviert -  Historie bleibt erhalten.';


--
-- Name: benutzer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.benutzer ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.benutzer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: benutzerrolle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.benutzerrolle (
    id bigint NOT NULL,
    bezeichnung character varying(60) NOT NULL
);


ALTER TABLE public.benutzerrolle OWNER TO postgres;

--
-- Name: TABLE benutzerrolle; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.benutzerrolle IS 'Definiert Rollen zur Berechtigungssteuerung (z.B. Admin, Moderator, Mitglied).';


--
-- Name: benutzerrolle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.benutzerrolle ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.benutzerrolle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buch (
    id bigint NOT NULL,
    titel character varying(255) NOT NULL,
    erscheinungsjahr date,
    isbn character varying(32),
    anbieter_benutzer_id bigint NOT NULL,
    genre_id bigint NOT NULL,
    sprache_id bigint NOT NULL,
    zustand_id bigint NOT NULL,
    status_id bigint NOT NULL,
    autor_id bigint NOT NULL,
    ausleihdauer_id bigint NOT NULL,
    verlag_id bigint NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.buch OWNER TO postgres;

--
-- Name: TABLE buch; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.buch IS 'Entitaet fuer angebotene Buecher inkl. Metadaten (Genre, Sprache, Zustand, Status) und Anbieter.';


--
-- Name: COLUMN buch.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.buch.is_active IS 'Soft-Delete: TRUE aktiv, FALSE deaktiviert.';


--
-- Name: buch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.buch ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.buch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    id bigint NOT NULL,
    genre character varying(80) NOT NULL
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- Name: TABLE genre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.genre IS 'Stammdaten fuer Buchgenres zur Kategorisierung und Suche.';


--
-- Name: lieferart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lieferart (
    id bigint NOT NULL,
    bezeichnung character varying(80) NOT NULL
);


ALTER TABLE public.lieferart OWNER TO postgres;

--
-- Name: TABLE lieferart; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.lieferart IS 'Stammdaten fuer Uebergabe-/Lieferarten (Abholung, Versand, etc.).';


--
-- Name: sprache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sprache (
    id bigint NOT NULL,
    sprache character varying(80) NOT NULL
);


ALTER TABLE public.sprache OWNER TO postgres;

--
-- Name: TABLE sprache; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sprache IS 'Stammdaten fuer Buchsprachen zur Filterung.';


--
-- Name: status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status (
    id bigint NOT NULL,
    status character varying(80) NOT NULL
);


ALTER TABLE public.status OWNER TO postgres;

--
-- Name: TABLE status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.status IS 'Stammdaten fuer Buchstatus (z.B. verfuegbar, ausgeliehen).';


--
-- Name: zustand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zustand (
    id bigint NOT NULL,
    zustand character varying(80) NOT NULL
);


ALTER TABLE public.zustand OWNER TO postgres;

--
-- Name: TABLE zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.zustand IS 'Stammdaten fuer Buchzustaende; genutzt fuer Transparenz vor/nach Ausleihe.';


--
-- Name: dm_vw_ausleihen; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.dm_vw_ausleihen AS
 SELECT av.id AS ausleihvorgang_id,
    av.von,
    av.bis,
    av.rueckgabe_am,
    ((av.bis - av.von) + 1) AS geplante_tage,
    (av.rueckgabe_am IS NULL) AS ist_offen,
    b.id AS buch_id,
    b.titel,
    g.genre,
    s.sprache,
    st.status AS buch_status,
    z1.zustand AS zustand_vor,
    z2.zustand AS zustand_nach,
    u.id AS entleiher_id,
    concat_ws(' '::text, u.vorname, u.nachname) AS entleiher_name,
    l.bezeichnung AS lieferart
   FROM ((((((((public.ausleihvorgang av
     JOIN public.buch b ON ((b.id = av.buch_id)))
     LEFT JOIN public.genre g ON ((g.id = b.genre_id)))
     LEFT JOIN public.sprache s ON ((s.id = b.sprache_id)))
     LEFT JOIN public.status st ON ((st.id = b.status_id)))
     LEFT JOIN public.zustand z1 ON ((z1.id = av.zustand_vor_ausleih)))
     LEFT JOIN public.zustand z2 ON ((z2.id = av.zustand_nach_ausleih)))
     JOIN public.benutzer u ON ((u.id = av.benutzer_id)))
     JOIN public.lieferart l ON ((l.id = av.lieferart_id)));


ALTER VIEW public.dm_vw_ausleihen OWNER TO postgres;

--
-- Name: rezension; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezension (
    id bigint NOT NULL,
    kommentar text,
    bewertung integer NOT NULL,
    benutzer_id bigint NOT NULL,
    buch_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_rez_bewertung CHECK (((bewertung >= 1) AND (bewertung <= 5)))
);


ALTER TABLE public.rezension OWNER TO postgres;

--
-- Name: TABLE rezension; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.rezension IS 'Bewertungen/Kommentare zu Buechern; pro Nutzer und Buch nur einmal.';


--
-- Name: COLUMN rezension.bewertung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.rezension.bewertung IS 'Bewertung 1..5; CHECK Constraint erzwingt den Bereich.';


--
-- Name: dm_vw_buch_rating; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.dm_vw_buch_rating AS
 SELECT b.id,
    b.titel,
    (avg(r.bewertung))::numeric(10,2) AS avg_rating,
    count(*) AS anzahl_reviews
   FROM (public.buch b
     JOIN public.rezension r ON ((r.buch_id = b.id)))
  GROUP BY b.id, b.titel;


ALTER VIEW public.dm_vw_buch_rating OWNER TO postgres;

--
-- Name: genre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.genre ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.genre_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lieferant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lieferant (
    id bigint NOT NULL,
    name character varying(180) NOT NULL
);


ALTER TABLE public.lieferant OWNER TO postgres;

--
-- Name: TABLE lieferant; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.lieferant IS 'Stammdaten fuer Lieferanten.';


--
-- Name: lieferant_abholort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lieferant_abholort (
    lieferant_id bigint NOT NULL,
    abholort_id bigint NOT NULL
);


ALTER TABLE public.lieferant_abholort OWNER TO postgres;

--
-- Name: TABLE lieferant_abholort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.lieferant_abholort IS 'Zuordnungstabelle: welcher Lieferant macht welchen Abholort.';


--
-- Name: lieferant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lieferant ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lieferant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lieferart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lieferart ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lieferart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ort (
    id bigint NOT NULL,
    stadt character varying(120) NOT NULL,
    plz integer NOT NULL,
    CONSTRAINT ck_ort_plz CHECK (((plz >= 0) AND (plz <= 99999)))
);


ALTER TABLE public.ort OWNER TO postgres;

--
-- Name: TABLE ort; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ort IS 'Stammdaten fuer Orte (Stadt/PLZ) zur ssrtlichen Zuordnung.';


--
-- Name: ort_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ort ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ort_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rezension_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rezension ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rezension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sprache_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sprache ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sprache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.status ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: verlag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verlag (
    id bigint NOT NULL,
    name character varying(180) NOT NULL
);


ALTER TABLE public.verlag OWNER TO postgres;

--
-- Name: TABLE verlag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.verlag IS 'Stammdaten fuer Verlage, wird von buch referenziert.';


--
-- Name: verlag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.verlag ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.verlag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zustand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.zustand ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.zustand_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: abholort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.abholort (id, adresse, ort_id) FROM stdin;
1	Bibliothek Mitte, Hauptstrasse 1	1
2	Bibliothek Nord, Hafenweg 12	2
3	Bibliothek Sued, Platz 3	3
4	Bibliothek West, Ring 99	4
5	InfoPoint Zentrum, Allee 5	5
6	InfoPoint Nord, Uniweg 10	6
7	InfoPoint, Sued	7
8	InfoPoint, West	8
9	InfoPoint Ost, Elbweg 4	9
10	Servicepoint, Bahnhofstrasse 8	10
\.


--
-- Data for Name: ausleihdauer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ausleihdauer (id, tage, bezeichnung) FROM stdin;
1	7	1 Woche
2	10	10 Tage
3	14	2 Wochen
4	21	3 Wochen
5	28	4 Wochen
6	30	1 Monat
7	35	5 Wochen
8	42	6 Wochen
9	56	8 Wochen
10	90	3 Monate
\.


--
-- Data for Name: ausleihvorgang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ausleihvorgang (id, benutzer_id, buch_id, zustand_vor_ausleih, zustand_nach_ausleih, von, bis, lieferart_id, rueckgabe_am, created_at) FROM stdin;
1	2	1	2	3	2025-01-01	2025-01-14	1	2025-01-12	2026-02-15 01:20:17.350562+01
2	3	2	3	3	2025-01-05	2025-01-19	2	2025-01-18	2026-02-15 01:20:17.350562+01
3	5	3	4	4	2025-01-10	2025-01-24	3	\N	2026-02-15 01:20:17.350562+01
4	8	4	3	4	2025-01-11	2025-02-10	1	\N	2026-02-15 01:20:17.350562+01
5	9	5	2	2	2025-01-15	2025-02-12	4	2025-02-01	2026-02-15 01:20:17.350562+01
6	10	6	5	6	2025-01-20	2025-02-03	5	\N	2026-02-15 01:20:17.350562+01
7	1	7	2	3	2025-01-22	2025-02-05	6	2025-02-04	2026-02-15 01:20:17.350562+01
8	4	8	4	4	2025-01-25	2025-02-08	7	\N	2026-02-15 01:20:17.350562+01
9	6	9	3	3	2025-01-28	2025-02-11	8	\N	2026-02-15 01:20:17.350562+01
10	7	10	6	6	2025-02-01	2025-02-15	2	2025-02-14	2026-02-15 01:20:17.350562+01
\.


--
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autor (id, vorname, nachname) FROM stdin;
1	Lukas	Rottinghaus
2	Erika	Musterfrau
3	Max	Mustermann
4	Laura	Weber
5	Tom	Tester
6	Sarah	Klein
7	David	Wolf
8	Nina	Bekcer
9	Paul	Hoffmann
10	Mia	Schulz
\.


--
-- Data for Name: benutzer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.benutzer (id, vorname, nachname, email, passwort, adresse, ort_id, benutzerrolle_id, is_active, created_at) FROM stdin;
1	Anna	Mueller	anna.mueller@example.com	hash$anna	Musterweg 1	1	2	t	2026-02-15 01:13:23.284147+01
2	Tom	Schmidt	tom.schmidt@example.com	hash$tom	Beispielstr 2	2	2	t	2026-02-15 01:13:23.284147+01
3	Lisa	Weber	lisa.weber@example.com	hash$lisa	Ring 3	3	2	t	2026-02-15 01:13:23.284147+01
4	Mark	Fischer	mark.fischer@example.com	hash$mark	Allee 4	4	3	t	2026-02-15 01:13:23.284147+01
5	Sara	Klein	sara.klein@example.com	hash$sara	Park 5	5	2	t	2026-02-15 01:13:23.284147+01
6	Jan	Wolf	jan.wolf@example.com	hash$jan	Weg 6	6	6	t	2026-02-15 01:13:23.284147+01
7	Nina	Becker	nina.becker@example.com	hash$nina	Gasse 7	7	5	t	2026-02-15 01:13:23.284147+01
8	Paul	Hoffmann	paul.hoffmann@example.com	hash$paul	Strasse 8	8	2	t	2026-02-15 01:13:23.284147+01
9	Mia	Schulz	mia.schulz@example.com	hash$mia	Platz 9	9	2	t	2026-02-15 01:13:23.284147+01
10	Leon	Krueger	leon.krueger@example.com	hash$leon	Hof 10	10	4	t	2026-02-15 01:13:23.284147+01
\.


--
-- Data for Name: benutzerrolle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.benutzerrolle (id, bezeichnung) FROM stdin;
1	Admin
2	Mitglied
3	Moderator
4	Gast
5	Mitarbeiter
6	Bibliothekar
7	Support
8	Verifizierter Nutzer
9	Sperre
10	System
\.


--
-- Data for Name: buch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.buch (id, titel, erscheinungsjahr, isbn, anbieter_benutzer_id, genre_id, sprache_id, zustand_id, status_id, autor_id, ausleihdauer_id, verlag_id, is_active, created_at) FROM stdin;
1	Der grosse Roman	2010-01-01	978-0000000001	1	1	1	2	1	1	3	1	t	2026-02-15 01:17:53.366437+01
2	Koelner Kriminalfall	2012-06-15	978-0000000002	2	2	1	3	1	2	2	2	t	2026-02-15 01:17:53.366437+01
3	Sterne ueber Europa	2018-03-10	978-0000000003	3	3	2	4	1	3	4	3	t	2026-02-15 01:17:53.366437+01
4	Drachenwald	2016-11-20	978-0000000004	4	4	1	3	1	4	5	4	t	2026-02-15 01:17:53.366437+01
5	Wirtschaft einfach erklaert	2020-02-02	978-0000000005	5	5	1	2	1	5	6	5	t	2026-02-15 01:17:53.366437+01
6	Das Leben von X	2014-09-09	978-0000000006	6	6	1	4	1	6	1	6	t	2026-02-15 01:17:53.366437+01
7	Kinder entdecken die Welt	2019-05-05	978-0000000007	7	7	1	2	1	7	7	7	t	2026-02-15 01:17:53.366437+01
8	Jugend im Wandel	2017-07-07	978-0000000008	8	8	2	5	1	8	8	8	t	2026-02-15 01:17:53.366437+01
9	Thriller: Der letzte Hinweis	2021-01-12	978-0000000009	9	9	1	2	1	9	9	9	t	2026-02-15 01:17:53.366437+01
10	Historische Spuren	2013-12-24	978-0000000010	10	10	1	6	1	10	10	10	t	2026-02-15 01:17:53.366437+01
\.


--
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre (id, genre) FROM stdin;
1	Roman
2	Krimi
3	Science-Fiction
4	Fantasy
5	Sachbuch
6	Biografie
7	Kinderbuch
8	Jugendbuch
9	Thriller
10	Historisch
\.


--
-- Data for Name: lieferant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lieferant (id, name) FROM stdin;
1	DHL
2	DPD
3	Hermes
4	UPS
5	GLS
6	FedEx
7	LocalCourier One
8	CityLogistik
9	Buecherbote GmbH
10	ExpressNow
\.


--
-- Data for Name: lieferant_abholort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lieferant_abholort (lieferant_id, abholort_id) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
\.


--
-- Data for Name: lieferart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lieferart (id, bezeichnung) FROM stdin;
1	Abholung
2	Lieferung Standard
3	Lieferung Express
4	Uebergabe vor Ort
5	Kontaktlos
6	Paketstation
7	Abholung Wochenende
8	Abholung Werktags
9	Lieferung PREMIUM
10	Digitale Bereitstellung
\.


--
-- Data for Name: ort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ort (id, stadt, plz) FROM stdin;
1	Berlin	10115
2	Hamburg	20095
3	Muenchen	80331
4	Koeln	50667
5	Frankfurt am Main	60311
6	Stuttgart	70173
7	Duesseldorf	40213
8	Leipzig	4109
9	Dresden	1067
10	Hannover	30159
\.


--
-- Data for Name: rezension; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezension (id, kommentar, bewertung, benutzer_id, buch_id, created_at) FROM stdin;
1	Spannend und gut geschrieben.	5	2	1	2026-02-15 01:18:38.514536+01
2	Solide Story, etwas lang.	4	3	2	2026-02-15 01:18:38.514536+01
3	Tolle Ideen, gutes Tempo.	5	5	3	2026-02-15 01:18:38.514536+01
4	Sehr atmosphaerisch.	4	8	4	2026-02-15 01:18:38.514536+01
5	Nuetzlich, aber trocken.	3	9	5	2026-02-15 01:18:38.514536+01
6	Beruehrend, empfehlenswert.	5	10	6	2026-02-15 01:18:38.514536+01
7	Perfekt fuer Kinder.	5	1	7	2026-02-15 01:18:38.514536+01
8	Guter Einstieg ins Thema.	4	4	8	2026-02-15 01:18:38.514536+01
9	Richtig fesselnd!	5	6	9	2026-02-15 01:18:38.514536+01
10	Historisch interessant.	4	7	10	2026-02-15 01:18:38.514536+01
14	Top	5	1	1	2026-02-21 01:24:44.797313+01
\.


--
-- Data for Name: sprache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sprache (id, sprache) FROM stdin;
1	Deutsch
2	Englisch
3	Franzoesisch
4	Spanisch
5	Italienisch
6	Niederlaendisch
7	Schwedisch
8	Norwegisch
9	Polnisch
10	Tuerkisch
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status (id, status) FROM stdin;
1	Verfuegbar
2	Ausgeliehen
3	Reserviert
4	Nicht verfuegbar
5	In Pruefung
6	Verloren
7	Beschaedigt
8	Im Versand
9	Zur Abholung bereit
10	Archiviert
\.


--
-- Data for Name: verlag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verlag (id, name) FROM stdin;
1	Alpha Verlag
2	Beta Books
3	Gamma Press
4	Delta Publishing
5	Epsilon Media
6	Zeta Verlagshaus
7	Omega Editions
8	Nordlicht Verlag
9	Suedstern Books
10	Hanseatische Presse
\.


--
-- Data for Name: zustand; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zustand (id, zustand) FROM stdin;
1	Neu
2	Wie neu
3	Sehr gut
4	Gut
5	Akzeptabel
6	Stark gebraucht
7	Mit Markierungen
8	Kleine Schaeden
9	Starke Schaeden
10	Unleserlich
\.


--
-- Name: abholort_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.abholort_id_seq', 10, true);


--
-- Name: ausleihdauer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ausleihdauer_id_seq', 10, true);


--
-- Name: ausleihvorgang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ausleihvorgang_id_seq', 14, true);


--
-- Name: autor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autor_id_seq', 10, true);


--
-- Name: benutzer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.benutzer_id_seq', 10, true);


--
-- Name: benutzerrolle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.benutzerrolle_id_seq', 10, true);


--
-- Name: buch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.buch_id_seq', 10, true);


--
-- Name: genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genre_id_seq', 10, true);


--
-- Name: lieferant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lieferant_id_seq', 10, true);


--
-- Name: lieferart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lieferart_id_seq', 10, true);


--
-- Name: ort_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ort_id_seq', 10, true);


--
-- Name: rezension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezension_id_seq', 21, true);


--
-- Name: sprache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sprache_id_seq', 10, true);


--
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_id_seq', 10, true);


--
-- Name: verlag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.verlag_id_seq', 10, true);


--
-- Name: zustand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zustand_id_seq', 10, true);


--
-- Name: abholort abholort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abholort
    ADD CONSTRAINT abholort_pkey PRIMARY KEY (id);


--
-- Name: ausleihdauer ausleihdauer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ausleihdauer
    ADD CONSTRAINT ausleihdauer_pkey PRIMARY KEY (id);


--
-- Name: ausleihvorgang ausleihvorgang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ausleihvorgang
    ADD CONSTRAINT ausleihvorgang_pkey PRIMARY KEY (id);


--
-- Name: autor autor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (id);


--
-- Name: benutzer benutzer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.benutzer
    ADD CONSTRAINT benutzer_email_key UNIQUE (email);


--
-- Name: benutzer benutzer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.benutzer
    ADD CONSTRAINT benutzer_pkey PRIMARY KEY (id);


--
-- Name: benutzerrolle benutzerrolle_bezeichnung_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.benutzerrolle
    ADD CONSTRAINT benutzerrolle_bezeichnung_key UNIQUE (bezeichnung);


--
-- Name: benutzerrolle benutzerrolle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.benutzerrolle
    ADD CONSTRAINT benutzerrolle_pkey PRIMARY KEY (id);


--
-- Name: buch buch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT buch_pkey PRIMARY KEY (id);


--
-- Name: genre genre_genre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_genre_key UNIQUE (genre);


--
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (id);


--
-- Name: lieferant_abholort lieferant_abholort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieferant_abholort
    ADD CONSTRAINT lieferant_abholort_pkey PRIMARY KEY (lieferant_id, abholort_id);


--
-- Name: lieferant lieferant_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieferant
    ADD CONSTRAINT lieferant_name_key UNIQUE (name);


--
-- Name: lieferant lieferant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieferant
    ADD CONSTRAINT lieferant_pkey PRIMARY KEY (id);


--
-- Name: lieferart lieferart_bezeichnung_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieferart
    ADD CONSTRAINT lieferart_bezeichnung_key UNIQUE (bezeichnung);


--
-- Name: lieferart lieferart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieferart
    ADD CONSTRAINT lieferart_pkey PRIMARY KEY (id);


--
-- Name: ort ort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ort
    ADD CONSTRAINT ort_pkey PRIMARY KEY (id);


--
-- Name: rezension rezension_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezension
    ADD CONSTRAINT rezension_pkey PRIMARY KEY (id);


--
-- Name: sprache sprache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sprache
    ADD CONSTRAINT sprache_pkey PRIMARY KEY (id);


--
-- Name: sprache sprache_sprache_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sprache
    ADD CONSTRAINT sprache_sprache_key UNIQUE (sprache);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- Name: status status_status_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_status_key UNIQUE (status);


--
-- Name: buch uq_buch_isbn; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT uq_buch_isbn UNIQUE (isbn);


--
-- Name: rezension uq_rezension_benutzer_buch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezension
    ADD CONSTRAINT uq_rezension_benutzer_buch UNIQUE (benutzer_id, buch_id);


--
-- Name: verlag verlag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verlag
    ADD CONSTRAINT verlag_name_key UNIQUE (name);


--
-- Name: verlag verlag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verlag
    ADD CONSTRAINT verlag_pkey PRIMARY KEY (id);


--
-- Name: zustand zustand_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zustand
    ADD CONSTRAINT zustand_pkey PRIMARY KEY (id);


--
-- Name: zustand zustand_zustand_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zustand
    ADD CONSTRAINT zustand_zustand_key UNIQUE (zustand);


--
-- Name: idx_av_benutzer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_av_benutzer ON public.ausleihvorgang USING btree (benutzer_id);


--
-- Name: idx_av_buch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_av_buch ON public.ausleihvorgang USING btree (buch_id);


--
-- Name: idx_av_offen_benutzer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_av_offen_benutzer ON public.ausleihvorgang USING btree (benutzer_id) WHERE (rueckgabe_am IS NULL);


--
-- Name: idx_buch_isbn; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_buch_isbn ON public.buch USING btree (isbn);


--
-- Name: idx_buch_titel; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_buch_titel ON public.buch USING btree (titel);


--
-- Name: idx_rez_buch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rez_buch ON public.rezension USING btree (buch_id);


--
-- Name: uq_av_buch_offen; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_av_buch_offen ON public.ausleihvorgang USING btree (buch_id) WHERE (rueckgabe_am IS NULL);


--
-- Name: abholort fk_abholort_ort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abholort
    ADD CONSTRAINT fk_abholort_ort FOREIGN KEY (ort_id) REFERENCES public.ort(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ausleihvorgang fk_av_benutzer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ausleihvorgang
    ADD CONSTRAINT fk_av_benutzer FOREIGN KEY (benutzer_id) REFERENCES public.benutzer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ausleihvorgang fk_av_buch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ausleihvorgang
    ADD CONSTRAINT fk_av_buch FOREIGN KEY (buch_id) REFERENCES public.buch(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ausleihvorgang fk_av_lieferart; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ausleihvorgang
    ADD CONSTRAINT fk_av_lieferart FOREIGN KEY (lieferart_id) REFERENCES public.lieferart(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ausleihvorgang fk_av_zustand_nach; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ausleihvorgang
    ADD CONSTRAINT fk_av_zustand_nach FOREIGN KEY (zustand_nach_ausleih) REFERENCES public.zustand(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ausleihvorgang fk_av_zustand_vor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ausleihvorgang
    ADD CONSTRAINT fk_av_zustand_vor FOREIGN KEY (zustand_vor_ausleih) REFERENCES public.zustand(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: benutzer fk_benutzer_ort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.benutzer
    ADD CONSTRAINT fk_benutzer_ort FOREIGN KEY (ort_id) REFERENCES public.ort(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: benutzer fk_benutzer_rolle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.benutzer
    ADD CONSTRAINT fk_benutzer_rolle FOREIGN KEY (benutzerrolle_id) REFERENCES public.benutzerrolle(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_anbieter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_anbieter FOREIGN KEY (anbieter_benutzer_id) REFERENCES public.benutzer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_ausleihdauer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_ausleihdauer FOREIGN KEY (ausleihdauer_id) REFERENCES public.ausleihdauer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_autor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_autor FOREIGN KEY (autor_id) REFERENCES public.autor(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_genre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_genre FOREIGN KEY (genre_id) REFERENCES public.genre(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_sprache; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_sprache FOREIGN KEY (sprache_id) REFERENCES public.sprache(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_status; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_status FOREIGN KEY (status_id) REFERENCES public.status(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_verlag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_verlag FOREIGN KEY (verlag_id) REFERENCES public.verlag(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: buch fk_buch_zustand; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buch
    ADD CONSTRAINT fk_buch_zustand FOREIGN KEY (zustand_id) REFERENCES public.zustand(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lieferant_abholort fk_la_abholort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieferant_abholort
    ADD CONSTRAINT fk_la_abholort FOREIGN KEY (abholort_id) REFERENCES public.abholort(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lieferant_abholort fk_la_lieferant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieferant_abholort
    ADD CONSTRAINT fk_la_lieferant FOREIGN KEY (lieferant_id) REFERENCES public.lieferant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rezension fk_rez_benutzer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezension
    ADD CONSTRAINT fk_rez_benutzer FOREIGN KEY (benutzer_id) REFERENCES public.benutzer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rezension fk_rez_buch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezension
    ADD CONSTRAINT fk_rez_buch FOREIGN KEY (buch_id) REFERENCES public.buch(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict QG3y4nzjz5eYXM37SiMkCaAonI4i4OOWpVohvJMdxQwUws4gMSdA9Vd142PvcWi

