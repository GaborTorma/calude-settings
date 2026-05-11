---
description: Intent-Driven Planning Phase 3 — Plan (tervezett változtatások + implementációs lépések) + teljes Spec-fájl mentése. Csak ennek az approve-ja jelenti a teljes terv jóváhagyását.
---

# Intent-Driven Planning — Plan (Phase 3)

Ez a command az elfogadott `Intent` + `Spec` alapján megírja a `Plan` szakaszt — atomic TODO lépések mérhető verifikációval (failing test → implementáció → passing test → commit), edge case-ek a `Failing test` mezőben. Approve után **menti a teljes Spec-fájlt** (`Intent` + `Spec` + `Plan` + üres `Megvalósítási napló` placeholder); ezután az `Intent`/`Spec`/`Plan` szakaszok fagyottak.

## Előfeltétel

A beszélgetésben legyen véglegesített `Intent` + `Spec`. Új sessionben olvasd a **Spec-fájl**t a lemezről, ha létezik. Ha bármelyik hiányzik, **kérdezz vissza** vagy küldd vissza a usert az előző fázishoz.

## Workflow

1. **`Plan` tervezete** az elfogadott `Intent` + `Spec` alapján → iteratív finomítás (lépések pontosítása, edge case-ek, verifikáció erősítése). A `Branch` sorba **konkrét név** kerüljön, ne placeholder.

2. **`ExitPlanMode` hívás**: a teljes **Spec-fájl** tartalma (mindhárom szakasszal) megy review-ra. Visszajelzés → iteráció → újra `ExitPlanMode`.

3. **Approve után — mentés**: kilépés a Plan harness-ből, és a véglegesített tartalom mentése a megegyezett **Spec-fájl** útvonalra.

4. **Session-javaslat**: tegyél indoklással ellátott ajánlást, hogy a megvalósítás **új sessionben** induljon (tisztább kontextus, kevesebb plan-mód-zaj — nagyobb feladatnál ajánlott) vagy **az aktuálisban folytatódjon** (kicsi, gyors feladat; a kontextus még friss). A döntés a useré.

5. **STOP**: implementáció csak a user explicit jóváhagyása után indulhat!

---

## Sablon

A `Plan` szakasz + `Megvalósítási napló` placeholder, amit a véglegesített `Intent` + `Spec` mögé fűzünk:

```markdown
## Plan

### Előfeltételek

- **Branch**: `<branch-name>` — `git checkout -b <branch-name>`
- <Mire van szükség a kezdés előtt (dep, env var, migration, feature flag, tesztkörnyezet, fixtures, mcp)?>

### Tervezett változtatások

A változás hatóköre — **mit** érint a változás. Kategóriák: módosítás (`CM`), hozzáadás (`CA`), törlés (`CD`). Line ref opcionális.

#### Módosítás

- **CM-01** — <Meglévő rész / fájl / pipeline — egy mondat, mit módosítunk benne.>
- **CM-02** — <...>

#### Hozzáadás

- **CA-01** — <Új rész / fájl / réteg — egy mondat, mit veszünk fel.>

#### Törlés

- **CD-01** — <Rész / fájl / referencia — egy mondat, mit távolítunk el.>

### Implementációs lépések

#### IS-01 — <Lépés rövid címe>

- **Művelet**: <konkrét teendő — milyen fájl(oka)t érint, milyen változás.>
- **Failing test**: <melyik teszt vagy assert reprodukálja a hiányosságot/bugot.>
- **Implementáció**: <a minimum kód, ami zöldre viszi a tesztet.>
- **Verify**: <pontos parancs vagy ellenőrzés, pl. `npm test path/to/file` zöld; manual: <X> működik.>
- **Commit**: `<conventional commit message>`

<!-- További lépések (#### IS-02, #### IS-03, ...) ugyanezzel a struktúrával. -->

### Globális verifikáció (a teljes Plan végén)

- **GV-01** — Minden lépés `Verify`-ja zöld.
- **GV-02** — Minden ismert edge case-hez van failing test és zöld.
- **GV-03** — Spec elfogadási kritériumok mind teljesítve.
- **GV-04** — Lint / typecheck / build hibamentes.
- **GV-05** — Manual smoke: <golden path egy mondatban>.

### Rollback / kockázat

- <Mi a visszaút, ha a Plan menet közben elakad — pl. "git revert <első commit>", "feature flag off".>
- <Legkockázatosabb lépés és mitigáció.>

## Megvalósítási napló

_Az implementáció során bővül. Minden bejegyzés végén commit-hash referencia: `(<commit-hash>)`._

- **IL-01** — <Eltérés / fix / follow-up leírás.> (`<commit-hash>`)

### Érintett fájlok (opcionális, hosszabb naplónál hasznos)

| Fájl                         | Naplóbejegyzések | Érintő commitok      |
| ---------------------------- | ---------------- | -------------------- |
| [path/to/file](path/to/file) | `IL-01`, `IL-03` | `<hash1>`, `<hash2>` |
```
