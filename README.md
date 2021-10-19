# neocheckin

Frontend til det nye checkin system, skrevet i Dart og Flutter.

Formålet med frontenden er at kunne bruge den på en Raspberry Pi, så du hjælper digselv ved at teste i Linux frem for Chromium.

Husk at ændre `apiUrl` konstanten i filen `/lib/utils/http_request.dart`, hvis du skal udvikle på appen.

**Husk, at hvis du kører Flutter på alting andet end en Chromium webapp, kan du få problemer ved at bruge `localhost` eller `127.0.0.1` som api url, da Flutter kørt som Android eller Linux app kører i en VM, så deres definition af `localhost` er virtuelmaskinen, og ikke din computer. Hvis du får problemer ved at bruge `localhost`, så brug i stedet din ip addresse på netværket.**