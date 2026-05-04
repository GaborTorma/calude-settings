# SocratiCode használat

- **Mi**: `socraticode` plugin — szemantikus kódkeresés, dependency graph és kontextus-elemzés indexelt codebase-eken.
- **Használd**: ismeretlen helyen lévő feature/koncepció megkeresésére, több fájlon átívelő struktúra-megértéshez, dependency feltérképezéshez, refactor-tervezéshez.
- **Ne használd**: ismert célfájlnál (`Read`), library dokumentációhoz (`context7`), korábbi beszélgetések visszakeresésére (`episodic-memory`).
- **Workflow**: `codebase_status` → `codebase_index` (ha nincs indexelve) → `codebase_search` (szemantikus keresés) → `codebase_graph_query` (dependency) → `codebase_context` (kontextus lekérés).
- **Preferencia**: feature/koncepció lookup → mindig SocratiCode. `find`/`grep`/`Read` körök csak konkrét, már lokalizált fájlon.
