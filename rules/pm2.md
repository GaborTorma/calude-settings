# PM2 — Node.js production futtatás és deploy

- **Mi**: `pm2` — Node.js process manager production-höz: cluster, auto-restart, log, monitoring, beépített SSH-alapú deploy (`pm2 deploy`).
- **Használd**: Szükség esetén Node.js/TypeScript production futtatás és deploy esetén. Root: `ecosystem.config.js` (`apps` + `deploy` szekció).
- **Ne használd**: dev, Python, Docker.
- **Konvenció**: `pm2 reload` (zero-downtime) preferált `restart` helyett; `pm2 save` + `pm2 startup` boot-perzisztenciára.
- **Graceful shutdown**: Ha PM2-t, akkor **kezelnie kell** a `SIGINT` / `SIGTERM` jelet — HTTP `server.close()`, in-flight requestek kivárása, DB / queue / cache connection lezárás.
