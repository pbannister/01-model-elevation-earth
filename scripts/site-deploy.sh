#!/bin/sh
#
# site-deploy.sh: publish the project site to the labs site.
#
# Feature: prompts/features/01-site-build.md
#
# Pushes site.out/ to ~/labs.bannister.us/projects/model-elevation-earth/ on
# the Dreamhost web server (the labs.bannister.us docroot), so the project
# pages live at:
#     https://labs.bannister.us/projects/model-elevation-earth/
#
# The homelab deploy (homelab: scripts/labs-deploy.sh) excludes this exact
# path, so the two deploys never fight: this project owns its pages under
# /projects/.
#
# Prerequisites:
#   - The bannister.us ssh alias with the key-2024-bannister.us identity
#     (see ~/.ssh/config).
#   - A built site (make site / make state && make site).
#
# SECURITY: the deploy aborts if the site output contains sensitive content
# (MAC addresses, private LAN IPs, usernames, home paths, key material) -
# the same gate the homelab deploy uses.
#
# Usage: site-deploy.sh
set -eu

DIRECTORY_SCRIPT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$DIRECTORY_SCRIPT/.." && pwd)
SITE_OUTPUT="$REPOSITORY_ROOT/site.out"
PROJECT_SLUG="model-elevation-earth"
TARGET_HOST="bannister.us"
TARGET_DIRECTORY="labs.bannister.us/projects/$PROJECT_SLUG"

# Sensitive-content patterns.  Keep in sync with the homelab deploy
# (homelab: scripts/labs-deploy.sh) and its tests/03-labs-site.sh.
PATTERNS='([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}|(^|[^0-9])(192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[01])\.)|preston|cainboy|/home/[a-zA-Z]|BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY'

if [ ! -d "$SITE_OUTPUT" ]; then
    echo "site-deploy: no build output at $SITE_OUTPUT; run 'make site' first" >&2
    exit 1
fi

if grep -rEn "$PATTERNS" "$SITE_OUTPUT" >/dev/null 2>&1; then
    echo "site-deploy: REFUSING to deploy; sensitive content found in $SITE_OUTPUT:" >&2
    grep -rEn "$PATTERNS" "$SITE_OUTPUT" | head -5 >&2
    exit 1
fi

# Ensure web-server-readable permissions on the build output (files 644, dirs 755).
chmod -R a+rX "$SITE_OUTPUT"

# The bannister.us host entry already sets User and IdentityFile.
# .gitkeep keeps site.out/ in git and must not be published.
rsync -az --delete --exclude '.gitkeep' -e ssh "$SITE_OUTPUT/" "$TARGET_HOST:$TARGET_DIRECTORY/"
echo "site-deploy: deployed $SITE_OUTPUT to $TARGET_HOST:$TARGET_DIRECTORY/"
