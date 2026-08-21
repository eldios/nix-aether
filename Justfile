# Run `just` with no arguments to see this list.
default:
    @just --list

# Build the package.
build:
    nice -n 19 nix build .#default

# Every check a push must pass.
ci:
    nice -n 19 nix flake check
    just build
