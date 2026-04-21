# Git workflow

- **Új projekt**: `git init` → `.gitignore` → `git commit -m "Initial commit"`.
- **Visszavonás**: `git revert <sha>` — ne patch-ekkel kombináld.
- **Tilos**: `--no-verify`, `push --force` main-re, `reset --hard` megerősítés nélkül.

## Conventional Commits

Formátum: `<type>(<scope>): <subject>` — scope opcionális, kebab-case.

**Típusok:**

| Type       | Jelentés                            | Semver |
| ---------- | ----------------------------------- | ------ |
| `feat`     | új feature                          | MINOR  |
| `fix`      | bugfix                              | PATCH  |
| `perf`     | performance                         | PATCH  |
| `refactor` | refactor (nincs viselkedésváltozás) | —      |
| `docs`     | dokumentáció                        | —      |
| `style`    | formázás (nincs kódváltozás)        | —      |
| `test`     | tesztek                             | —      |
| `build`    | build rendszer                      | —      |
| `ci`       | CI konfig                           | —      |
| `chore`    | karbantartás                        | —      |
| `revert`   | korábbi commit visszavonása         | —      |

**Subject szabályok:**

- Imperatív, jelen idő: `add`, `fix` — ne `added`/`fixed`.
- Max 72 karakter, kisbetűvel, végén nincs pont.
- Konkrét (`feat: improve API` ❌ → `feat: add rate limiting to auth endpoints` ✅).

**Breaking change**: `feat!:` vagy `BREAKING CHANGE:` footer a body-ban.

**Példák:**

```
feat(auth): add OAuth2 login support
fix(api): handle empty response from external service
refactor: extract user service for testability
feat!: remove deprecated v1 API endpoints
```

**Body (opcionális)**: akkor írj, ha a _miért_ nem triviális. Magyarázd a motivációt, ne a mit.

**Footer**: `Fixes #123`, `Closes #456`, `BREAKING CHANGE: ...`.
