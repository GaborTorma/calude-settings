---
name: spec
description: Intent-Driven Planning — Intent (WHY) → Spec (WHAT) → Plan (HOW)
---

# Intent-Driven Planning

A **Spec-fájl** létrehozása három szakaszszal — `Intent` (WHY) → `Spec` (WHAT) → `Plan` (HOW). Az `Intent` + `Spec` az első promptból készül, iteratív finomítás után és **egyértelmű user jóváhagyással** zárul; a `Plan` csak ezután kerül megírásra szintén iteratív finomítással.

## A Spec-fájl szakaszai

### `## Intent` — WHY

Egy bekezdés: mi a probléma vagy motiváció, mit szeretnénk elérni, és miről ismerjük majd fel a sikert.

**Nem TODO; Nem implentáció!**

### `## Spec` — WHAT

Hatókör, viselkedés, funkcionális + nem-funkcionális követelmények, elfogadási kritériumok.

**Nem implentáció!**

### `## Plan` — HOW

Atomic TODO lépések **mérhető verifikációval** (failing test → implementáció → passing test → commit). Az edge case-eket az érintett lépés `Failing test` dokumentálja.

## Elnevezés

**Slug** — az `Intent` magvát tükröző kebab-case azonosító. Claude javasolja, a user hagyja jóvá. Ez köti össze a **Spec-fájlt** és a branchet.

**Spec-fájl** — `.spec/<slug>.md`. Kategorizáláshoz almappa is használható: `.spec/<group>/<slug>.md` (pl. `.spec/auth/oauth-token-rotation.md`).

**Prefix** — az `Intent` jellege szerint: `feat` (új funkció), `fix` (bug- vagy regressziófix), `refactor` (viselkedést nem érintő szerkezeti átalakítás).

**Branch** — `<prefix>/<slug>`. Ha a repo látható branch-konvenciót használ, ahhoz igazodj.

## Workflow

1. **`Intent` + `Spec`** az első promptból → bemutatás a usernek → iteratív finomítás (kérdések, pontosítás, hatókör-szűkítés) **egy darab közös jóváhagyásig**.

2. **`Plan` megírása** csak az elfogadott `Intent` + `Spec` után. A `Plan` Branch sorába **konkrét név** kerüljön, ne placeholder.

3. **`ExitPlanMode` után az ELSŐ feladat**: a három szakaszt tartalmazó fájl mentése az előző bekezdésben definiált **Spec-fájl** útvonalra.
   - **Fájlnév-egyeztetés**: javasold a slug-ot és — ha indokolt — az opcionális csoport-mappát; a user vagy elfogadja, vagy ad másikat.
   - **Mentés után STOP**: a megvalósítás csak a user **explicit jóváhagyása után** indulhat — implicit "ok" nincs.
   - **Session-javaslat**: a jóváhagyás kérésekor Claude tegyen ajánlást, hogy a megvalósítást érdemes-e **új sessionben** indítani (tisztább kontextus, kevesebb plan-mód-zaj, nagyobb feladatnál ajánlott) vagy az **aktuálisban folytatni** (kicsi, gyors feladat; a context még friss és releváns). Az ajánlás indoklással menjen, a döntést a user hozza meg.

---

## Sablon

A **Spec-fájl**ba másold be ezt a teljes skeletont, töröld a nem releváns alszakaszokat, és töltsd ki a `<...>` placeholder-eket. A workflow szerint az `Intent` + `Spec` szakasz először készül; a `Plan` szakasz placeholder-ben marad, és csak a jóváhagyás után töltöd ki.

```markdown
# <Spec-fájl címe — egy mondatban a feature / feladat>

## Intent

<Egy bekezdés (~3-6 mondat), amely megválaszolja: mi a jelenlegi probléma vagy motiváció, mit szeretnénk elérni, és miről ismerjük majd fel, hogy sikerült.>

## Spec

### Hatókör (in scope)

- <Mit érint a változás: komponensek, fájlok, modulok, felületek.>
- <Felhasználói / API viselkedés, ami változik.>

### Funkcionális követelmények (kötelező)

- <Megfigyelhető viselkedés #1 — input → output.>
- <Megfigyelhető viselkedés #2.>

### Nem-funkcionális követelmények (ha vannak ilyenek)

- **Performance**: <pl. p95 < 200ms, max memória, throughput.>
- **Biztonság / adatvédelem**: <auth, secret-kezelés, PII.>
- **Kompatibilitás**: <verziók, böngészők, runtime, OS.>
- **Egyéb**: <a11y, i18n, observability, ha releváns.>

### Elfogadási kritériumok

- [ ] <Mérhető kritérium #1 — pl. "X teszt zöld".>
- [ ] <Mérhető kritérium #2 — pl. "manual smoke: lépés A → B → C működik".>
- [ ] <Mérhető kritérium #3.>

### NEM-célok (out of scope)

- <Amit explicit nem csinálunk meg, hogy ne csússzon a hatókör.>
- <Későbbre halasztott rész-feladatok.>

### Nyitott kérdések (ha vannak)

- <Kérdés a usernek vagy stakeholdernek — jóváhagyás előtt le kell zárni!>

## Plan

### Előfeltételek

- **Branch**: `<branch-name>` — `git checkout -b <branch-name>`
- <Mire van szükség a kezdés előtt: dep, env var, migration, feature flag.>
- <Tesztkörnyezet / fixtúra elérhető.>

### Implementációs lépések

#### 1. <Lépés rövid címe>

- **Művelet**: <konkrét teendő — milyen fájl(oka)t érint, milyen változás.>
- **Failing test**: <melyik teszt vagy assert reprodukálja a hiányosságot/bugot.>
- **Implementáció**: <a minimum kód, ami zöldre viszi a tesztet.>
- **Verify**: <pontos parancs vagy ellenőrzés, pl. `npm test path/to/file` zöld; manual: <X> működik.>
- **Commit**: `<conventional commit message>`

#### 2. <Lépés rövid címe>

- **Művelet**: <...>
- **Failing test**: <...>
- **Implementáció**: <...>
- **Verify**: <...>
- **Commit**: `<conventional commit message>`

### Globális verifikáció (a teljes Plan végén)

- [ ] Minden lépés `Verify`-ja zöld.
- [ ] Minden ismert edge case-hez van failing test és zöld.
- [ ] Spec elfogadási kritériumok mind teljesítve.
- [ ] Lint / typecheck / build hibamentes.
- [ ] Manual smoke: <golden path egy mondatban>.

### Rollback / kockázat

- <Mi a visszaút, ha a Plan menet közben elakad — pl. "git revert <első commit>", "feature flag off".>
- <Legkockázatosabb lépés és mitigáció.>
```
