services:
  nix:
    image: nixos/nix:latest
    container_name: nix-builder
    privileged: true
    restart: unless-stopped

    volumes:
      - nix-store:/nix/store
      - nix-var:/nix/var
      - .:/work
      - ./cachix:/root/.config/cachix

    working_dir: /work

    environment:
      NIX_CONFIG: experimental-features = nix-command flakes
      CACHIX_CACHE_NAME: your-cache-name
      CACHIX_AUTH_TOKEN: ${CACHIX_AUTH_TOKEN}

    entrypoint: /work/entrypoint.sh
