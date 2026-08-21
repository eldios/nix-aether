# Aether packaged for Nix: the Svelte frontend is built first and handed
# to the Go build, which embeds it; wails itself is not needed, the
# bindings are committed upstream.
{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  webkitgtk_4_1,
  copyDesktopItems,
}:

let
  pname = "aether";
  version = "4.29.2";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "aether";
    tag = "v${version}";
    hash = "sha256-UPcuDY8cPPY72vLZ1LpklzxK2lTl+qLjpHY8FhOWYfs=";
  };

  frontend = buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version;
    src = "${src}/frontend";
    # Upstream's release ships a package.json newer than its lockfile;
    # this one is regenerated from that package.json, nothing else.
    postPatch = ''
      cp ${./frontend-package-lock.json} package-lock.json
    '';
    npmDepsFetcherVersion = 2;
    npmDepsHash = "sha256-kGXnJHKRNZvmdwIy0uEAfu8YZMbEJVlLcAcF+3KPW7s=";
    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-iIqJCRVgs1kg2nymuRO1FWdwbb8OhSAaQTCqaIdOPec=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    webkitgtk_4_1
  ];

  # The tag wails' Makefile picks when only webkit2gtk-4.1 exists.
  tags = [ "webkit2_41" ];

  preBuild = ''
    cp -r ${frontend} frontend/dist
  '';

  postInstall = ''
    install -Dm644 li.oever.aether.desktop $out/share/applications/li.oever.aether.desktop
    install -Dm644 li.oever.aether.url-handler.desktop $out/share/applications/li.oever.aether.url-handler.desktop
    install -Dm644 assets/aether-icon-512.png $out/share/icons/hicolor/512x512/apps/aether.png
  '';

  meta = {
    description = "Visual theming application: extract colors from wallpapers and apply cohesive themes";
    homepage = "https://github.com/bjarneo/aether";
    license = lib.licenses.mit;
    mainProgram = "aether";
    platforms = lib.platforms.linux;
  };
}
