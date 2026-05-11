---
name: methodology
description: Intent-Driven Planning módszertan kontextusa — slug/branch konvenciók, Spec-fájl elhelyezés, élő dokumentum fegyelem. Aktiválódik ha a user `intent-driven-planning:` slash commandot használ, `.spec/*.md` fájllal dolgozik, vagy a current branch slug-ja egyezik egy létező Spec-fájl basenamejével.
---

# Intent-Driven Planning — Methodology

Az Intent-Driven Planning három fázisra (intent → spec → plan) bontja a feature/refactor előkészítését + egy mellék-command (`review`) tervezés közbeni koherencia-ellenőrzéshez. Mindegyik külön slash commanddal indul; fájlt csak az `intent-driven-planning:plan` ír.

| Fázis | Command                         | Tartalom                                                                                      |
| ----- | ------------------------------- | --------------------------------------------------------------------------------------------- |
| 1     | `intent-driven-planning:intent` | Probléma, célok, sikerkritérium, NEM-célok, későbbi megvalósítás                              |
| 2     | `intent-driven-planning:spec`   | Funkcionális + nem-funkcionális követelmények, elfogadási kritériumok                         |
| 3     | `intent-driven-planning:plan`   | Tervezett változtatások + implementációs lépések (TDD-szerűen) + teljes **Spec-fájl** mentése |
| —     | `intent-driven-planning:review` | Tervezés közben futtatható koherencia-check a draft-on (report-only)                          |

A három fázis-command iteratív review-t használ a Plan harness-en keresztül; csak `intent-driven-planning:plan` approve-ja jelenti a teljes terv jóváhagyását és a fájl mentését. A `review` nem mutál semmit, és nem kötődik fázishoz — bármelyik draft-állapotra adaptívan fut.

## Elnevezés

**Slug** — az `Intent` magvát tükröző kebab-case azonosító. Claude javasolja, a user hagyja jóvá. Ez köti össze a **Spec-fájl**t és a branchet.

**Spec-fájl** — `.spec/<slug>.md`. Kategorizáláshoz almappa is használható: `.spec/<group>/<slug>.md` (pl. `.spec/auth/oauth-token-rotation.md`).

**Prefix** — az `Intent` jellege szerint: `feat` (új funkció), `fix` (bug- vagy regressziófix), `refactor` (viselkedést nem érintő szerkezeti átalakítás).

**Branch** — `<prefix>/<slug>`. Ha a repo látható branch-konvenciót használ, ahhoz igazodj.

## Élő dokumentum fegyelem

A **Spec-fájl** szakaszai különböző életciklust követnek a Plan-jóváhagyás körül:

- **Session indulásakor**: ha a current branch slug-ja egyezik egy `.spec/<slug>.md` vagy `.spec/<group>/<slug>.md` fájl basenamejével, vagy a user explicit **Spec-fájl**ra hivatkozik, **olvasd el** a fájlt az első tájékozódó lépések között.

- **Tervezés közben — backward-propagation szükséges**:
   - Ha a `Spec` írásakor kiderül valami, ami módosítja az `Intent`-et, az `Intent`-et **frissíteni kell**.
   - Ha a `Plan` írásakor kiderül valami, ami a `Spec`-et vagy `Intent`-et érinti, azokat is frissíteni kell.
   - A `Plan`-jóváhagyás egy konzisztens, koherens dokumentumra menjen át.

- **Plan-jóváhagyás után — fagyott állapot**: az `Intent`, `Spec`, `Plan` szakaszokat **többé nem módosítjuk**. Ezek tükrözik, mire vállalkoztunk a tervezéskor.

- **Implementáció közben — `## Megvalósítási napló` bővül**: az eltérések, fix-ek és follow-up-ok a Plan után fűzött `Megvalósítási napló` szakaszba kerülnek. Az eredeti három szakasz változatlan marad — a napló adja a "tényleges megvalósítás" rétegét.

- **Intent szintű változás** (a probléma vagy cél maga változik): állj meg, és egyeztess a userrel.
