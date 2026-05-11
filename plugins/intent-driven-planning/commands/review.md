---
description: Intent-Driven Planning review — a tervezés közbeni koherencia-ellenőrzés a beszélgetésben lévő `Intent`/`Spec`/`Plan` drafton. Adaptív (csak amit eddig megfogalmaztunk), report-only, nem mutál semmit.
---

# Intent-Driven Planning — Review

Ez a command a **tervezés közbeni** **Spec-fájl**-draftot ellenőrzi: anomáliákat, inkonzisztenciákat, lefedési réseket keres a `Intent` / `Spec` / `Plan` szakaszok között. **Pure dokumentum-ellenőrzés, kód nem érinti** — a `review` futáskor a kód még nem létezik, mert legkésőbb a `Plan` szakasz finomításakor fut.

## Soft-enforcement

Ha a beszélgetésben **nincs aktív Spec-draft** (sem előző `intent`/`spec`/`plan` futtatás eredménye, sem ExitPlanMode-prezentáció), válaszolj röviden és állj le:

> A `review` a tervezés közbeni Spec-draftot ellenőrzi — most nincs ilyen a beszélgetésben. Indíts előbb egy `intent`/`spec`/`plan` commandot, és onnan futtasd újra.

Ha viszont van draft, folytasd a check-kel.

## Mit elemez (adaptív)

A jelen lévő szakaszoknak megfelelően (kumulatív — a `+` jelzi az előző sorhoz hozzáadódó kategóriákat):

| Draft-állapot              | Aktív kategóriák                                 |
| -------------------------- | ------------------------------------------------ |
| Csak `Intent`              | 1, 4 (Célok vs NEM-célok), 5, 7, 8               |
| `Intent` + `Spec`          | + 2 (Intent ↔ Spec lefedés), 6 (Spec teljesség)  |
| `Intent` + `Spec` + `Plan` | + 3 (Spec ↔ Plan lefedés), 6 (Plan teljesség is) |

### Kategóriák

1. **Strukturális teljesség**:

- A draft kötelező szakaszai megvannak? `Készítve` dátum kitöltve?
- Ha `Plan` van: a `Branch` sor konkrét név (nem placeholder)?

2. **Intent ↔ Spec lefedés**:

- Az `Intent.Célok` (`GL-NN`) minden eleméhez tartozik legalább egy követelmény a `Spec`-ben?
- Van-e `Spec`-követelmény, ami egyik célhoz sem köthető?

3. **Spec ↔ Plan lefedés**:

- Minden `Spec.Elfogadási kritérium` köthető legalább egy `Plan`-lépés `Verify`-jéhez?
- Van-e `Plan`-lépés, ami egyetlen Spec-követelményt sem szolgál?

4. **NEM-célok ütközés**:

- Az `Intent`-en belül van-e logikai ütközés `Célok` (`GL-NN`) és `NEM-célok` (`NG-NN`) között?
- A `Spec` vagy `Plan` ír-e olyat, amit az `Intent.NEM-célok` explicit kizár?

5. **Nyitott kérdések**:

- Az `Intent` és `Spec` `Nyitott kérdések` szakaszában maradt megválaszolatlan tétel?
- Akármelyik szakaszban van `TODO` / `TBD` / `?` marker?

6. **Szakasz-teljesség**:

- `Spec`: minden `FR-NN` megfigyelhető viselkedés (input → output formában)? `AC-NN` mind mérhető?
- `Plan`: minden `#### IS-NN` lépésnél kitöltve `Művelet` / `Failing test` / `Implementáció` / `Verify` / `Commit`?
- `Tervezett változtatások` (`CM-NN` / `CA-NN` / `CD-NN`) bulletjei egyszerűek, könnyen érthetőek?

7. **Terminológiai konzisztencia**:

- Ugyanaz a komponens-név / fogalom mindenütt?
- NFR-ben említett metrika konkretizálva van-e az elfogadási kritériumokban?

8. **Egyszerűsítés / tömörítés**:

- Van-e olyan rész, ami **rövidebb, lényegre törőbb** megfogalmazással kifejezhető az értelem elvesztése nélkül?
- Tartalmi **duplikáció**? Felesleges töltelékszó, redundáns minősítő ("nyilvánvalóan fontos", "általában szükséges"), feleslegesen ismételt magyarázat?

## Output formátum

Three-tier severity:

```
   1. 🚨 Mit, hol, miért anomália — Javasolt megoldás
   2. ⚠️ ...
   3. ℹ️ ...
```

**Severity-besorolás**:

- **Critical** 🚨: strukturális hiány, NEM-célok ütközés, megválaszolatlan kérdés Plan-jóváhagyás előtt, üres kötelező placeholder
- **Warning** ⚠️: Spec ↔ Plan lefedés-rés, terminológiai eltérés, hiányos Plan-lépés mező
- **Info** ℹ️: redundancia, fogalmazási finomítás, opcionális mező nincs kitöltve

## Workflow

1. **Olvas**: az utolsó `ExitPlanMode`-ban prezentált draft, vagy a beszélgetésben legfrissebb Intent/Spec/Plan-tervezet. Ha nincs ilyen → soft-enforcement leállás.

2. **Elemez**: az aktuális draft-állapotnak megfelelő aktív kategóriák **mind**, egyben (nem áll meg az első critical-nél).

3. **Riportál**: chatben a fenti formátumban. **Ennyi.**

## Mit NEM csinál

- **Nem nyúl semmihez** — nem írja át a draftot, nem ír fájlt, nem hív `ExitPlanMode`-ot
- **Nem fut tesztet, nem olvas kódot, nem nézi a git-et** — a draft önmagával vett konzisztenciáját elemzi
- **Nem blokkol semmit** — a user dönti el, mit kezd a találatokkal (manuálisan finomít a `intent`/`spec`/`plan` újrafuttatásával)
