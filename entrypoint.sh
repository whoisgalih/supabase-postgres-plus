#!/usr/bin/env sh
set -e

# 1. Git safety (flakes)
git config --global --add safe.directory /work || true

# 2. Install cachix if missing
if ! command -v cachix >/dev/null 2>&1; then
  nix profile install nixpkgs#cachix
fi

# 3. Authenticate Cachix (token via env)
if [ -n "$CACHIX_AUTH_TOKEN" ]; then
  echo "$CACHIX_AUTH_TOKEN" | cachix authtoken --stdin
fi

# 4. Enable cache
if [ -n "$CACHIX_CACHE_NAME" ]; then
  cachix use "$CACHIX_CACHE_NAME"
fi

# 5. Start uploader
if [ -n "$CACHIX_CACHE_NAME" ]; then
  cachix watch-store "$CACHIX_CACHE_NAME" &
fi

# Keep container alive
exec sleep infinity
