<!-- /spec slash command — Intent-Driven Planning -->

# Spec-fájl élő dokumentum-fegyelem

## Mi a felelősség

- **Session indulásakor**: ha a current branch slug-ja (a `<prefix>/<slug>` utolsó komponense) egyezik egy `.spec/<slug>.md` vagy `.spec/<group>/<slug>.md` fájl basenamejével, vagy a user explicit Spec-fájlra hivatkozik, **olvasd el** ezt a fájlt az első tájékozódó lépések között. Ez a forrásdokumentum a megvalósításhoz.
- **Implementáció közben — élő dokumentum**: ha bármi változik a Spec-hez vagy Plan-hez képest (új edge case, módosított hatókör, kihagyott vagy átsorolt lépés, megváltozott elfogadási kritérium), a Spec-fájlt **azonnal frissítsd** a változások alapján. A Spec-fájl mindig a megvalósítás aktuális állapotát tükrözze, ne a kezdeti tervet.
- **Intent szintű változásnál** (a probléma vagy cél maga változik): állj meg, és egyeztess a userrel.
