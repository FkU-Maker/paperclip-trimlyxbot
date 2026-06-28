#!/bin/sh
set -e

# Inject Claude OAuth credentials from env vars (Pro subscription auth)
if [ -n "$CLAUDE_OAUTH_ACCESS_TOKEN" ] && [ -n "$CLAUDE_OAUTH_REFRESH_TOKEN" ]; then
    CREDS_DIR="${PAPERCLIP_HOME:-/paperclip}/.claude"
    CREDS_FILE="$CREDS_DIR/.credentials.json"
    mkdir -p "$CREDS_DIR"
    cat > "$CREDS_FILE" <<CREDS_EOF
{"claudeAiOauth":{"accessToken":"${CLAUDE_OAUTH_ACCESS_TOKEN}","refreshToken":"${CLAUDE_OAUTH_REFRESH_TOKEN}","expiresAt":${CLAUDE_OAUTH_EXPIRES_AT:-0},"scopes":["user:file_upload","user:inference","user:mcp_servers","user:profile","user:sessions:claude_code"],"subscriptionType":"pro","rateLimitTier":"default_claude_ai"}}
CREDS_EOF
    chown -R "${USER_UID:-1000}:${USER_GID:-1000}" "$CREDS_DIR" 2>/dev/null || true
    echo "docker-entrypoint.sh: Claude OAuth credentials injected"
fi

# Capture runtime UID/GID from environment variables, defaulting to 1000
PUID=${USER_UID:-1000}
PGID=${USER_GID:-1000}

# Without root we can neither remap the node user (usermod/groupmod/chown)
# nor switch users (gosu needs CAP_SETUID/CAP_SETGID), so exec directly.
# This covers Kubernetes restricted PodSecurity (runAsNonRoot + runAsUser)
# as well as platforms that assign arbitrary UIDs (e.g. OpenShift); for the
# latter a UID/GID mismatch is unfixable here, so warn instead of letting
# usermod fail cryptically and keep volume-permission issues diagnosable.
if [ "$(id -u)" -ne 0 ]; then
    if [ "$(id -u)" -ne "$PUID" ] || [ "$(id -g)" -ne "$PGID" ]; then
        echo "docker-entrypoint.sh: running unprivileged as $(id -u):$(id -g); cannot remap to requested ${PUID}:${PGID}" >&2
    fi
    exec "$@"
fi

# Adjust the node user's UID/GID if they differ from the runtime request
# and fix volume ownership only when a remap is needed
changed=0

if [ "$(id -u node)" -ne "$PUID" ]; then
    echo "Updating node UID to $PUID"
    usermod -o -u "$PUID" node
    changed=1
fi

if [ "$(id -g node)" -ne "$PGID" ]; then
    echo "Updating node GID to $PGID"
    groupmod -o -g "$PGID" node
    usermod -g "$PGID" node
    changed=1
fi

if [ "$changed" = "1" ]; then
    chown -R node:node /paperclip
fi

exec gosu node "$@"
