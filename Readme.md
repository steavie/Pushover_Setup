# Pushover – Systemweites Push-Kommando

Einmaliges Setup, danach einfach:

```bash
push "Backup abgeschlossen"
push "Fehler" "Cronjob ist fehlgeschlagen"
```

Funktioniert für **root und alle Benutzer**, auch aus Skripten und Cronjobs.

---

## Installation

```bash
sudo bash install.sh
```

Das Script fragt interaktiv nach:
- **App API Token** → von [pushover.net](https://pushover.net) unter „Your Applications"
- **User Key** → von [pushover.net](https://pushover.net) oben rechts
- **Standard-Titel** → wird verwendet wenn nur eine Nachricht ohne Titel angegeben wird

Am Ende wird automatisch eine Testnachricht gesendet.

---

## Verwendung

```bash
# Nur Nachricht (Standard-Titel wird verwendet)
push "Server wurde neu gestartet"

# Mit eigenem Titel
push "Backup" "Backup vom 27.03. erfolgreich"

# Aus einem Skript
if ! some_command; then
  push "Fehler" "some_command ist fehlgeschlagen"
fi

# In einem Cronjob
0 3 * * * /usr/local/bin/push "Backup" "Nacht-Backup gestartet"
```

---

## Was wird installiert?

| Datei | Zweck |
|-------|-------|
| `/etc/pushover.env` | Tokens (nur root kann schreiben, alle lesen) |
| `/usr/local/bin/push` | Das push-Kommando |

---

## Token ändern

```bash
sudo nano /etc/pushover.env
```

Keine Skripte müssen angepasst werden – alle Skripte lesen automatisch den neuen Token.

---

## Deinstallieren

```bash
sudo rm /usr/local/bin/push /etc/pushover.env
```

---

*Stand: März 2026 — minifamilie*
