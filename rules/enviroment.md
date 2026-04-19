# Environment

- **Minden env-specifikus beállítás `.env`-be.** (Pl.: API key, host, port, DB URL, secret, feature flag).
- **Commit**: `.env.example` placeholder értékekkel.
- **`.gitignore`**: `.env`, `.env.*`, `credentials.json`, `*.pem`, `*.key`, `!.env.example`.
- **Bootstrap**: `.env.example` + `.gitignore` az első commit része.
