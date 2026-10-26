# CI image with Claude Code preinstalled, so jobs that run `claude -p` skip installing
# apt packages and Claude Code on every run. The workflow rebuilds it when a new Claude
# Code version is released.
FROM debian:13-slim

ARG CLAUDE_VERSION=latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends git curl ca-certificates jq mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Runs as root because CI runners clone and run jobs as root; the installer puts the
# binary under ~/.local, so HOME must stay /root for jobs to find it.
RUN curl -fsSL https://claude.ai/install.sh | bash -s "$CLAUDE_VERSION" \
    && /root/.local/bin/claude --version

# The image is the update mechanism: a job must not upgrade itself mid-run.
ENV PATH="/root/.local/bin:${PATH}" \
    DISABLE_AUTOUPDATER=1
