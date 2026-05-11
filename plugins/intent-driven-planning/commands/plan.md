---
description: Intent-Driven Planning Phase 3 — Plan (tervezett változtatások + implementációs lépések) + teljes Spec-fájl mentése. Csak ennek az approve-ja jelenti a teljes terv jóváhagyását.
---

# Intent-Driven Planning — Plan (Phase 3)

Ez a command az elfogadott `Intent` + `Spec` alapján megírja a `Plan` szakaszt — atomic TODO lépések mérhető verifikációval (failing test → implementáció → passing test → commit), edge case-ek a `Failing test` mezőben. Approve után **menti a teljes Spec-fájlt** (`Intent` + `Spec` + `Plan` + üres `Megvalósítási napló` placeholder); ezután az `Intent`/`Spec`/`Plan` szakaszok fagyottak.

## Előfeltétel

A beszélgetésben legyen véglegesített `Intent` + `Spec`. Új sessionben olvasd a **Spec-fájl**t a lemezről, ha létezik. Ha bármelyik hiányzik, **kérdezz vissza** vagy küldd vissza a usert az előző fázishoz.

## Workflow

1. **`Plan` tervezete** az elfogadott `Intent` + `Spec` alapján → iteratív finomítás (lépések pontosítása, edge case-ek, verifikáció erősítése). A `Branch` sorba **konkrét név** kerüljön, ne placeholder.

   **Milestone-bontás megfontolása**: ha a Spec AC-i és a tervezett változtatások több, **e2e-tesztelhető és release-worthy egységre** bonthatók (pl. külön rétegek, önállóan demo-able increment-ek), javasolj `MS-XX` milestone-csoportokat. Kisebb, egyetlen e2e-egységnyi feladatnál maradj a flat `IS-XX` listánál. A user dönt a Plan-review-ban.

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

<!--
  Két alak közül VÁLASSZ EGYET, a másik blokkot töröld:
  • Flat (alapeset) — kis feladat, egyetlen e2e-tesztelhető egység.
  • Multi-stage (opcionális) — több e2e-tesztelhető, release-worthy increment;
    MS-XX milestone-csoportok, lokális `MS-XX:IS-YY` lépésszámozás, milestone-onkénti MV-XX verify.
-->

<!-- ───────────── OPCIÓ A — Flat alak ───────────── -->

#### IS-01 — <Lépés rövid címe>

- **Művelet**: <konkrét teendő — milyen fájl(oka)t érint, milyen változás.>
- **Failing test**: <melyik teszt vagy assert reprodukálja a hiányosságot/bugot.>
- **Implementáció**: <a minimum kód, ami zöldre viszi a tesztet.>
- **Verify**: <pontos parancs vagy ellenőrzés, pl. `npm test path/to/file` zöld; manual: <X> működik.>
- **Commit**: `<conventional commit message>`

<!-- További lépések (#### IS-02, #### IS-03, ...) ugyanezzel a struktúrával. -->

<!-- ───────────── OPCIÓ B — Multi-stage alak ───────────── -->

#### MS-01 — <Milestone rövid címe, ami egy e2e-tesztelhető release-worthy egységet ír le>

##### MS-01:IS-01 — <Lépés rövid címe>

- **Művelet**: <konkrét teendő — milyen fájl(oka)t érint, milyen változás.>
- **Failing test**: <melyik teszt vagy assert reprodukálja a hiányosságot/bugot.>
- **Implementáció**: <a minimum kód, ami zöldre viszi a tesztet.>
- **Verify**: <pontos parancs vagy ellenőrzés, pl. `npm test path/to/file` zöld; manual: <X> működik.>
- **Commit**: `<conventional commit message>`

<!-- További step-ek: ##### MS-01:IS-02, ##### MS-01:IS-03, ... -->

##### MS-01 — Milestone verify

- **MV-01** — Minden `MS-01:IS-YY` `Verify`-ja zöld.
- **MV-02** — Integrációs / cross-cutting smoke: <e2e parancs vagy lépés, ami az MS-01 egységet végigfuttatja>.
- **MV-03** — Branch release-worthy: az MS-01-hez tartozó Spec AC-XX teljesítve, a korábbi funkciók nem törtek el.

<!-- További milestone-ok (#### MS-02, #### MS-03, ...) ugyanezzel a struktúrával, lokális IS-számozással és saját MV blokkal. -->

### Globális verifikáció (a teljes Plan végén)

- **GV-01** — Minden lépés (`IS-XX` vagy `MS-XX:IS-YY`) és — ha vannak — minden `MV-XX` zöld.
- **GV-02** — Minden ismert edge case-hez van failing test és zöld.
- **GV-03** — Spec elfogadási kritériumok mind teljesítve.
- **GV-04** — Lint / typecheck / build hibamentes.
- **GV-05** — Manual smoke: <golden path egy mondatban>.

### Rollback / kockázat

- <Mi a visszaút, ha a Plan menet közben elakad — pl. "git revert <első commit>", "feature flag off".>
- <Legkockázatosabb lépés és mitigáció.>

## Megvalósítási napló

<!-- Az implementáció során bővül. Csak a Plan és a megvalósult kód közötti **deltákat** rögzíti (eltérés, fix, follow-up, refactor) — a Plan szerint lefutott `IS-XX` / `MS-XX:IS-YY` lépéseket nem ismétli. -->

### IL-01 — <Bejegyzés rövid címe>

- **Típus**: Eltérés | Fix | Follow-up | Refactor
- **Érintett**: `IS-XX` / `MS-XX:IS-YY` / `AC-XX` / `FR-XX` (vagy `—`, ha a Plan-ban nem szerepelt)
- **Indoklás**: <1-2 mondat a motivációról / triggerről: mi váltotta ki a deltát — mi derült ki, milyen bugot fedeztünk fel, miért nem volt megfelelő a Plan-megközelítés.>
- **Delta**: <1-2 mondat — a delta konkrét tartalma: hogyan tértünk el / mit fixáltunk / mit vettünk fel follow-up-ként. **Ne ismételd a Plan-tételt** — csak a deltát írd le.>
- **Commit**: `<commit-hash1>`, `<commit-hash2>`

<!-- További bejegyzések (### IL-02, ### IL-03, ...) ugyanezzel a struktúrával. -->
```
