# Secrets & environment

- **Minden env-specifikus beállítás `.env`-be.** Soha hardcoded (API key, host, port, DB URL, feature flag).
- **Commitolandó**: `.env.example` placeholder értékekkel.
- **Soha ne commitold**: `.env`, `.env.*`, `credentials.json`, `*.pem`, `*.key`.
- **`.gitignore`**: `.env`, `.env.*`, `!.env.example`.
- **Bootstrap**: `.env.example` + `.gitignore` az első commit része.
