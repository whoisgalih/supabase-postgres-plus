{ lib
, stdenv
, fetchFromGitHub
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "pg_ivm";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "sraoss";
    repo = "pg_ivm";
    rev = (builtins.fromJSON (builtins.readFile ./versions.json)).pg_ivm."${version}".revision; 
    hash = (builtins.fromJSON (builtins.readFile ./versions.json)).pg_ivm."${version}".hash;
  };

  buildInputs = [ postgresql ];

  buildPhase = ''
    runHook preBuild
    make PG_CONFIG=${postgresql}/bin/pg_config
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,share/postgresql/extension}

    # Standard PGXS install (most extensions support this)
    make install \
      PG_CONFIG=${postgresql}/bin/pg_config \
      DESTDIR=$out \
      pkglibdir=$out/lib \
      datadir=$out/share/postgresql

    # Fallback copies (if upstream install didn't respect dirs above)
    if ls *.control >/dev/null 2>&1; then
      install -Dm644 *.control -t $out/share/postgresql/extension
    fi
    if [ -d sql ]; then
      install -Dm644 sql/*.sql -t $out/share/postgresql/extension || true
    fi
    if ls *.sql >/dev/null 2>&1; then
      install -Dm644 *.sql -t $out/share/postgresql/extension || true
    fi
    if ls *.so >/dev/null 2>&1; then
      install -Dm755 *.so -t $out/lib || true
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Incremental View Maintenance (IVM) extension for PostgreSQL";
    homepage = "https://github.com/sraoss/pg_ivm";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
}