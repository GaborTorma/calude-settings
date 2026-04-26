# Spec-Goal-Test Driven Development (SGT)

**Csak [OpenSpec](https://github.com/Fission-AI/OpenSpec) környezetben**: van `./openspec` mappa

- **Mi**: Spec-Driven Development három réteggel — Spec (mit/miért) → Goal (hogyan - mérhető outcome) → Test-first TODO (implement).
- **Használd**: nem-triviális feature, multi-fájlos változás, brownfield iteráció, ahol az "implement" előtt értelmes az alignment.
- **Ne használd**: egyszerű módosítás, typo, rename, single-line fix, throwaway script, exploratory spike, CSS tweak, copy-change, layout-finomítás.

## Workflow - OpenSpec mapping

| SGT réteg / módszertan                                                      | OpenSpec artifact        | Tartalom                                                                 |
| --------------------------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------ |
| **Spec**-Driven Development                                                 | `proposal.md` + `specs/` | "MIÉRT" és "MIT" — szándék, hatókör, megközelítés + delta specs          |
| [**Goal**-Driven Execution](karpathy-guidelines.md#4-goal-driven-execution) | `design.md`              | "HOGYAN" — atomic, mérhető elfogadási kritériumokkal + tech megközelítés |
| **Test**-Driven Development                                                 | `tasks.md`               | TODO — 1. failing teszt, 2. implementáció, 3. passing teszt, 4. commit   |
