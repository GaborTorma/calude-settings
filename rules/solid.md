# SOLID elvek

- **S — Single Responsibility**: egy osztálynak egy oka legyen a változásra. Ha a név `and`/`manager`/`helper`-t tartalmaz, valószínűleg túl sokat csinál.
- **O — Open/Closed**: nyitott kiterjesztésre, zárt módosításra. Új viselkedést új kóddal, ne átírással. Absztrakciót csak 2-3 konkrét eset után vezess be.
- **L — Liskov Substitution**: subtípus helyettesíthető legyen a szülővel. Subclass ne szigorítsa a precondition-t vagy gyengítse a postcondition-t.
- **I — Interface Segregation**: egy kliens ne függjön olyan metódusoktól, amiket nem használ. Több kicsi interface > egy nagy.
- **D — Dependency Inversion**: magas szintű modulok ne függjenek alacsony szintűektől. Függőségeket kívülről injektálj, ne a middle-ben instanciálj.

**Megjegyzés**: eszköz, nem cél. Egyszerű script-nek nem kell DI container. Jel hogy túl messzire mentél: több absztrakció, mint konkrét implementáció.
