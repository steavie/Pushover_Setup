# Pushover – Push-Nachrichten vom System verschicken

## Was ist das hier?

Dieses Script richtet auf deinem System ein einfaches Kommando namens `push` ein.  
Damit kannst du von überall – aus dem Terminal, aus Skripten oder aus automatischen Aufgaben (Cronjobs) – **Push-Nachrichten direkt aufs Handy schicken**.

Zum Beispiel:
- „Backup abgeschlossen"
- „Fehler beim Scan"
- „Server wurde neu gestartet"

Die Nachrichten kommen über den Dienst **[Pushover](https://pushover.net)** – eine kleine App (einmalig ~5 €), die zuverlässig Benachrichtigungen auf iPhone oder Android liefert.

Funktioniert auf **macOS und Linux**.

---

## Was brauche ich dafür?

1. Die **Pushover-App** auf deinem Handy installiert (iOS oder Android)
2. Einen **kostenlosen Account** auf [pushover.net](https://pushover.net)
3. Dort zwei Dinge notieren:
   - **User Key** – steht oben auf der Startseite nach dem Login
   - **App API Token** – einmalig eine neue „Application" anlegen, dann den Token kopieren

---

## Installation

Terminal öffnen und ausführen:

```bash
sudo bash install.sh
```

Das Script fragt dich nach User Key und App Token, speichert sie sicher auf dem System und sendet am Ende eine Testnachricht. Wenn die Nachricht auf dem Handy ankommt – fertig.

---

## Verwendung

Danach reicht im Terminal:

```bash
push "Hallo, das ist eine Testnachricht"
```

Oder mit einem eigenen Titel:

```bash
push "Backup" "Das Backup vom 27.03. war erfolgreich"
```

Auch aus eigenen Skripten heraus:

```bash
push "Fehler" "Etwas ist schiefgelaufen"
```

---

## Was wird installiert?

| Datei | Wo | Was |
|-------|----|-----|
| `push` | `/usr/local/bin/push` | Das Kommando das du tippst |
| Zugangsdaten | `/etc/pushover.env` | User Key & Token – nur lokal, nicht im Repo |

Die Tokens liegen **nie im Repo** und werden **nicht geteilt**.

---

## Token ändern oder neu setzen

```bash
sudo nano /etc/pushover.env
```

Alle Skripte die `push` verwenden, nutzen automatisch den neuen Token.

---

## Deinstallieren

```bash
sudo rm /usr/local/bin/push /etc/pushover.env
```

---

*Stand: März 2026 — minifamilie*
