---
name: check-rules
description: Egy újonnan írt vagy módosított rules/*.md fájl ellenőrzése — formátum, hiányzó részek, ütközés más szabályokkal, átfedés/duplikáció. Használd amikor új szabályt írtál a rules/ mappába vagy egy meglévőt módosítottál és validálni szeretnéd lefutás előtt.
---

# Check-rules skill

Egy `rules/*.md` fájlt ellenőrzöl: formátum, hiányzó részek, ütközés más szabályokkal, átfedés/duplikáció. Csak riportot adsz, **nem módosítasz fájlokat**.

## Lépések

### 1. Cél fájl meghatározása

A felhasználó argumentuma jelzi a fájlt: `/check-rules rules/foo.md`.

Ha nem adott argumentumot:

```bash
git status --short rules/
```

- Pontosan 1 módosított vagy új `rules/*.md` van → azt vedd.
- 0 vagy >1 → kérdezd meg a felhasználótól, melyiket nézze. Ne tippelj.

A választott fájl elérési útját jegyezd meg `<target>` néven a riport végéig.

### 2. Formátum / struktúra ellenőrzés

Olvasd be a `<target>` fájlt teljes egészében (`ctx_read`).

A `rules/*.md` kanonikus szerkezete (lásd `rules/context7.md`, `rules/episodic-memory.md`, `rules/socraticode.md`, `rules/pm2.md`):

- `# <Cím>` (H1) — kötelező
- **Mi** — rövid definíció, kötelező
- **Használd** — mikor alkalmazandó, kötelező
- **Ne használd** — mikor nem, kötelező
- **Workflow** — lépések, opcionális
- **Preferencia** / **Konvenció** — opcionális

Ellenőrizd:

- van-e H1 cím
- a kötelező hármas (Mi / Használd / Ne használd) megvan-e — bármelyik hiányzik → `✗ Hiányzó`
- nincs-e benne YAML front-matter (a `rules/*.md` plain markdown, csak a `commands/*.md`-nek van frontmatter-e) → ha van, jelezd
- a fájl 50 sor alatt van-e (a megnézett rule fájlok mind rövidek; ha hosszabb, említsd, de nem hiba)

### 3. CLAUDE.md import-ellenőrzés

```bash
grep -n "@~/.claude/rules/" CLAUDE.md
```

- Keresd a `<target>` fájlnevét a találatok között.
- Ha **nincs** ott → flag: hiányzik a `CLAUDE.md`-ből, nem fog betöltődni.
- Ha új fájlt adsz hozzá: javasolj sort, ahova illik (a `CLAUDE.md`-ben a sorrend témakör szerinti — irányelvek, MCP-eszközök, environment/git/build/versioning/pm2).

### 4. Ütközés- és átfedés-vizsgálat

```bash
ls rules/*.md
```

Olvasd be az **összes többi** `rules/*.md` fájlt (`<target>` kivételével) és a `CLAUDE.md` inline szekcióit (a `CLAUDE.md`-ben van inline "Nyelvválasztás" és "lean-ctx" szakasz).

Két dolgot keress:

- **Átfedés / duplikáció**: ugyanaz a téma vagy konkrét szabály két fájlban is szerepel. Pl. ha a `<target>` ír git-konvencióról, és a `git.md` is tárgyalja → átfedés. Javaslat: melyikből töröljük, vagy egyiket a másikra hivatkoztassuk.
- **Konfliktus**: két fájl ugyanarra a kérdésre **ellentmondó** tanácsot ad. Pl. egyik tiltja, másik javasolja ugyanazt az eszközt.

A találatokhoz **konkrét sorhivatkozást** adj: `rules/<fájl>.md:N-M`.

### 5. Riport

Strukturált magyar markdown riport. Csak azokat a szekciókat írd ki, amelyek **nem üresek**.

```markdown
## ✓ Rendben

- <amit megfelelőnek talált>

## ✗ Hiányzó / hiányos

- <pl. nincs "Ne használd" szekció>
- <pl. nincs felvéve a CLAUDE.md-be (javasolt hely: <sor>)>

## ⚠ Ütközés

- `rules/X.md:12-18` ↔ `<target>:5-9` — <röviden miben mond mást>

## ↻ Átfedés / duplikáció

- `rules/X.md` és `<target>` mindkettő tárgyalja: <téma>. Javaslat: <merge / törlés / hivatkozás>
```

Zárd egy 1 mondatos összegzéssel:

- **Rendben** — semmi hiba, mehet.
- **Kisebb javítás kell** — csak `Hiányzó` találat van, nincs ütközés.
- **Ütközés rendezendő mielőtt megy** — `Ütközés` vagy érdemi `Átfedés` találat van.

### 6. Döntés-kérdezés minden találatra

A riport után **minden egyes** `Hiányzó`, `Ütközés` és `Átfedés` tételre tegyél fel egy konkrét kérdést a felhasználónak — ne neki kelljen kitalálnia, mit válasszon. Olyan stílusban, mint a tervezés (`AskUserQuestion`):

- Számozd a tételeket (`1.`, `2.`, …) és minden tételhez adj **2-4 konkrét opciót**.
- Az opciók legyenek **végrehajtható döntések**, ne kérdések. Pl. `(a) szúrd be a CLAUDE.md-be a 3. sor után`, `(b) hagyd ki, projekt-specifikus marad`.
- Az utolsó opció mindig: `(x) hagyd, nem kell most foglalkozni`.

Példa minta:

```markdown
## Mit csináljak?

**1.** Hiányzik a "Ne használd" szekció a `rules/foo.md`-ből.

- (a) Generáljak egy javaslatot a fájl jellege alapján és írjam be?
- (b) Adj inputot, és én beleírom?
- (c) Hagyd üresen, nem kötelező.

**2.** `rules/foo.md` és `rules/git.md` is tárgyalja a commit-konvenciót (`foo.md:8-15` ↔ `git.md:20-30`).

- (a) Töröljem a duplikációt a `foo.md`-ből, hagyjam meg a `git.md`-ben?
- (b) Cseréljem a `foo.md`-ben hivatkozásra: "Lásd [git.md](git.md#conventional-commits)"?
- (c) Olvaszd össze a kettőt egy fájlba, és töröld a másikat?
- (x) Hagyd, szándékos a redundancia.
```

Várd meg a választ (`1a, 2b` formában is jó), majd hajtsd végre a kiválasztott akciókat. Ha a felhasználó mind `(x)`-et választja, csak a riport marad.

## Megkötések

- **A 1-5. lépésben ne módosíts** semmit, csak olvasol és riportolsz.
- A 6. lépés döntései után végrehajthatsz módosítást — de **csak a felhasználó által kiválasztott opciók szerint**.
- Ne vizsgáld a `commands/*.md`-t, csak a `rules/*.md`-t.
