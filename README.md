# DLBDSPBDM01_D - Buchtausch-Plattform

## 1. Projektübersicht

Dieses Projekt implementiert eine relationale Datenbank für eine Buchtausch-Plattform.


## 2. Funktionsumfang
###  Funktionen
- Bücher anbieten und verwalten
- Ausleihvorgänge durchführen
- Rückgaben dokumentieren
- Rezensionen und Bewertungen speichern
- Benutzer- und Stammdaten verwalten

### Views / Reports
- Top Bücher nach Ausleihen
- Ausleihen pro Monat (Trendanalysen)
- Durchschnittliche Buchbewertungen
- Analyse von Zustandsveränderungen
- Materialisierte Views zur Performance-Optimierung


## 3. Datenbankarchitektur

### 3.1 Aufbau

Die relationale Datenbank ist normalisiert und stellt Datenintegrität durch Constraints sicher.

#### Zentrale Tabellen
- `benutzer`
- `buch`
- `ausleihvorgang`
- `rezension`
- `lieferant_abholort`

#### Stammdatentabellen
- `genre`
- `sprache`
- `zustand`
- `status`
- `lieferart`
- `abholort`
- `ausleihdauer`
- `autor`
- `benutzerolle`
- `lieferant`
- `lieferart`
- `ort`
- `verlag`


## 4. Reporting & Views

### Reporting Views
| ID | Name | Beschreibung |
|----|------|-------------|
| RV-01 | Faktensicht Ausleihen | Denormalisierte Basis für Analysen |
| RV-02 | Buchbewertung | Durchschnittliche Bewertung pro Buch |

### Reporting Queries
| ID | Name | Zweck |
|----|------|------|
| RP-01 | Top Bücher | Beliebteste Bücher |
| RP-02 | Ausleihen pro Monat | Zeitliche Trends |
| RP-03 | Ausleihhäufigkeit je Buch | Nutzungsanalyse |

---

## 5. Datenintegrität & Constraints

Die Datenbank stellt Konsistenz durch folgende Techniken dar:

- **PRIMARY KEY**: eindeutige Identifikation von Datensätzen
- **FOREIGN KEY**: referenzielle Integrität
- **NOT NULL**: Pflichtfelder (z.B. Benutzer bei Ausleihe)
- **UNIQUE**: verhindert Doppelbewertungen
- **CHECK**: gültige Datumsbereiche bei Ausleihen


## 6. Testfälle zur Robustheit

Zur Validierung der Datenintegrität wurden Negativtests durchgeführt:

| Testfall | Regel | Erwartung |
|--------|------|---------|
| TC-01 | NOT NULL | Fehler bei NULL-Werten |
| TC-02 | UNIQUE | Verhindert Doppelbewertungen |
| TC-03 | CHECK | Ungültige Datumsbereiche blockiert |
| TC-04 | FOREIGN KEY | Ungültige Referenzen verhindert |

Fehlerhafte Eingaben werden korrekt von der Datenbank abgewiesen.


## 7. Performance & Optimierung

Zur Verbesserung der Abfrageperformance wurden Indizes auf:

- Foreign Keys
- Suchspalten (z.B. Titel)
- häufig genutzte Join-Spalten

implementiert.


## 8. Voraussetzungen

mindestens PostgreSQL 13


## 9. Installation & Ausführung
Eine Installationsanleitung ist in "Installationsanleitung.pdf" beschrieben. Die Datei ist im Rootpfad des Projekts zu finden.
