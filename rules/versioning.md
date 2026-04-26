# Verziókezelés

- **Séma**: SemVer (`MAJOR.MINOR.PATCH`).
- **Tag**: `v1.2.3` tag (`git push --tags`)
- **`CHANGELOG.md`**: tooling generálja.
- **Release**: **manuális, helyi**, nem CI auto-release!

## Node — `release-it` + `@release-it/conventional-changelog`

- Dev dep
- `.release-it.json`:
   - `tagName: v${version}`
   - `npm.publish: false` default
   - `github.release: true`
   - plugin preset `conventionalcommits`
- `package.json` script:
   - `"release": "release-it"`.

## Python — `commitizen`

- Dev dep
- `pyproject.toml`
   - `[tool.commitizen]`
      - `version_provider = "pep621"`
      - `tag_format = "v$version"`
      - `update_changelog_on_bump = true`
- `[project] version` a single source.
