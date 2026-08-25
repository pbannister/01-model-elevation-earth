#!/bin/sh
#
# Test for the site deploy script (scripts/site-deploy.sh).
# Runs the deploy script against a temporary repository copy, so the real
# site.out/ is never touched and no network is used: a fake rsync on PATH
# records the invocation instead of copying anything.
# Verifies the deploy refuses without a build, refuses sensitive content
# (the leak gate), and otherwise calls rsync with the expected target and
# options (including the .gitkeep exclusion).
set -eu

DIRECTORY_SCRIPT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$DIRECTORY_SCRIPT/.." && pwd)
SCRIPT_DEPLOY="$REPOSITORY_ROOT/scripts/site-deploy.sh"

[ -f "$SCRIPT_DEPLOY" ] || {
    echo '05-site-deploy: missing scripts/site-deploy.sh' >&2
    exit 1
}

DIRECTORY_TEMPORARY=$(mktemp -d)
trap 'rm -rf "$DIRECTORY_TEMPORARY"' EXIT HUP INT TERM

mkdir -p "$DIRECTORY_TEMPORARY/scripts" "$DIRECTORY_TEMPORARY/bin"
cp "$SCRIPT_DEPLOY" "$DIRECTORY_TEMPORARY/scripts/site-deploy.sh"
SCRIPT_DEPLOY_COPY="$DIRECTORY_TEMPORARY/scripts/site-deploy.sh"
SITE_OUTPUT="$DIRECTORY_TEMPORARY/site.out"
FILE_RSYNC_ARGS="$DIRECTORY_TEMPORARY/rsync-args.txt"

# A fake rsync that records its arguments and never touches the network.
cat > "$DIRECTORY_TEMPORARY/bin/rsync" <<EOF
#!/bin/sh
printf '%s\n' "\$@" > "$FILE_RSYNC_ARGS"
exit 0
EOF
chmod +x "$DIRECTORY_TEMPORARY/bin/rsync"

# Without a build the deploy refuses.
if PATH="$DIRECTORY_TEMPORARY/bin:$PATH" sh "$SCRIPT_DEPLOY_COPY" >/dev/null 2>&1; then
    echo '05-site-deploy: deploy succeeded without a build' >&2
    exit 1
fi

mkdir -p "$SITE_OUTPUT"
printf '%s\n' '<h1>Global Elevation Model Dataset</h1>' > "$SITE_OUTPUT/index.html"

# With a clean build the deploy calls rsync with the expected target.
PATH="$DIRECTORY_TEMPORARY/bin:$PATH" sh "$SCRIPT_DEPLOY_COPY" >/dev/null

grep -q 'bannister.us:labs.bannister.us/projects/model-elevation-earth/$' "$FILE_RSYNC_ARGS" || {
    echo '05-site-deploy: rsync target is wrong' >&2
    exit 1
}

grep -q -- '--delete' "$FILE_RSYNC_ARGS" || {
    echo '05-site-deploy: rsync missing --delete' >&2
    exit 1
}

grep -q -- '--exclude' "$FILE_RSYNC_ARGS" || {
    echo '05-site-deploy: rsync missing the .gitkeep exclude' >&2
    exit 1
}

grep -q -- '.gitkeep' "$FILE_RSYNC_ARGS" || {
    echo '05-site-deploy: rsync does not exclude .gitkeep' >&2
    exit 1
}

# With sensitive content the deploy refuses and rsync is never called.
printf '%s\n' 'MAC aa:bb:cc:dd:ee:ff' > "$SITE_OUTPUT/leak.txt"
rm -f "$FILE_RSYNC_ARGS"

if PATH="$DIRECTORY_TEMPORARY/bin:$PATH" sh "$SCRIPT_DEPLOY_COPY" >/dev/null 2>&1; then
    echo '05-site-deploy: deploy succeeded with sensitive content' >&2
    exit 1
fi

[ ! -f "$FILE_RSYNC_ARGS" ] || {
    echo '05-site-deploy: rsync ran despite the leak gate' >&2
    exit 1
}

echo '05-site-deploy: ok'
exit 0
