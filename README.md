# neocheckin

Frontend til det nye checkin system, skrevet i Dart og Flutter.

Formålet med frontenden er at kunne bruge den på en Raspberry Pi, så du hjælper digselv ved at teste i Linux frem for Chromium.

Når du skal teste eller bygge på Linux, er det vigtigt at omdøbe mappen fra "flutter-app" til "flutter_app" el.lign., da den nogengange ikke kan finde ud af at bygge, hvis der er et bindestreg i navnene.

Husk at ændre config filen i `/assets/settings.conf`, eller skab den hvis den eksisterer.

Der er givet en eksempelfil om hvordan `settings.conf` skal ligne i `/assets/example.conf`, så du kan evt. kopiere `example.conf` og omdøbe den til `settings.conf`

**Husk, at hvis du kører Flutter på alting andet end en Chromium webapp, kan du få problemer ved at bruge `localhost` eller `127.0.0.1` som API url, da Flutter kørt som Android eller Linux app kører i en VM, så deres definition af `localhost` er virtuelmaskinen, og ikke din computer. Hvis du får problemer ved at bruge `localhost`, så brug i stedet din ip addresse på netværket.**