# claude-code-ci

Container image for CI jobs that run [Claude Code](https://code.claude.com/docs) headless
(`claude -p`): Debian slim with `git`, `curl`, `jq`, the MariaDB client (`mariadb`, for read-only
lookups in the database of the app) and Claude Code already installed, so
jobs don't install them on every run.

```yaml
# GitLab CI
fix:
  image: ghcr.io/adriadam10/claude-code-ci:latest
  script:
    - claude -p "..." --permission-mode acceptEdits
```

## Tags

- `latest`: newest Claude Code release.
- `X.Y.Z`: that Claude Code version.
- `sha-XXXXXXX`: a specific commit of this repo.

Images are built for `linux/amd64` and `linux/arm64`.

## Updates

The workflow runs daily: it reads the latest Claude Code version and builds the image only
if that tag is not published yet. Auto-update is disabled inside the image
(`DISABLE_AUTOUPDATER=1`), so a job always runs the version of the tag it pulled.
Dependabot keeps the Debian base image and the actions up to date.

## Notes

- Runs as root, like most CI jobs; Claude Code lives in `/root/.local/bin`.
- `ANTHROPIC_API_KEY` must come from the CI secrets, never from the image.

## License

MIT
