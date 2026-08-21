# nix-aether

Nix packaging for [Aether](https://github.com/bjarneo/aether), the
visual theming application that extracts colors from wallpapers and
applies cohesive themes. Use it as a flake input with
`overlays.default`, or run it directly:

```bash
nix run github:eldios/nix-aether
```

The upstream release ships a frontend lockfile out of sync with its
manifest; this repo carries a regenerated one until that is fixed.
