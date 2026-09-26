# CLI distribution contract

This tap is the macOS Homebrew publication authority for the ORES/BeamScale/Scintilla command-line tools. Formulae are downstream release metadata, not a substitute for proving the source package.

Target formula names:

- `bmscl` -> `beamscale/bmscl-cli`
- `bmscl-gleam` -> `beamscale/bmscl-cli-gleam`
- `scintilla` -> `scintilla-run/scintilla-cli`
- `ores-stack` -> `ores-stack/ores-stack-cli`

A formula may be added or updated only after its source repository has one immutable release identity and the same source revision has passed its native-install and zed-pkg distribution gates. Formulae must never point at `main`, another moving branch, or a mutable package version.

Every formula must:

1. use a public immutable source/release artifact;
2. verify SHA-256 for every downloaded artifact;
3. install the documented executable name;
4. have a `test do` block that executes a non-mutating command such as `--help` or `--version`;
5. declare runtime dependencies explicitly (notably Erlang/OTP for `bmscl-gleam`);
6. preserve the source repository's version/provenance identity;
7. pass syntax, `brew audit --strict`, install, `brew test`, reinstall/test, and uninstall on Apple Silicon and Intel macOS.

## Current promotion blockers

- `bmscl`: distribution PR exists, but its Rust dependency graph still needs a committed `Cargo.lock` before an immutable release/tag is published.
- `bmscl-gleam`: source is private, so Homebrew needs a public immutable release artifact rather than a private repository URL.
- `scintilla`: zed-pkg authority already exists; cross-platform native-install proof is under review before publishing/updating a Homebrew version.
- `ores-stack`: the canonical migration repository is not release-complete yet; do not publish from deprecated `ORESoftware/ores-stack`.

No placeholder formula should be committed to make the tap look complete. A missing formula is preferable to a formula whose source, checksum, or platform proof is not ready.
