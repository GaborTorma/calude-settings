# SocratiCode használat

- **Mi**: `socraticode` plugin — szemantikus kódkeresés, dependency graph és kontextus-elemzés indexelt codebase-eken.
- **Használd**: komplex kódnavigációhoz, több fájlon átívelő struktúra-megértéshez, dependency feltérképezéshez, refactor-tervezéshez.
- **Ne használd**: egyszerű fájl-olvasáshoz (arra `Read`/`Grep` való), library dokumentációhoz (arra `context7` való), korábbi beszélgetések visszakeresésére (arra `episodic-memory` való).
- **Workflow**: `codebase_status` (indexelt-e?) → `codebase_search` (szemantikus keresés) → `codebase_graph_query` (dependency) → `codebase_context` (kontextus lekérés).
- **Index**: ha nincs indexelve, `codebase_index`-szel kell előkészíteni — ez időbe telhet.
- **Preferencia**: több fájlon átnyúló kérdéseknél SocratiCode > ismételt `Grep`/`Read` körök.
