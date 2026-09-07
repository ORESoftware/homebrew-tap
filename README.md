# ORESoftware public Homebrew tap

## zed-pkg CLI

Install the public zed-pkg package manager (not the Zed editor):

```sh
brew install oresoftware/tap/zed-cli
zed --version
zed-binary --version
```

The fully qualified formula name selects this tap explicitly. Homebrew fetches
the published v0.3.0 archive for macOS or Linux, on Apple Silicon/ARM64 or x86-64,
and verifies its committed SHA-256 before installing `zed` and `zed-binary`.
These are upstream release archives, not newly claimed Homebrew bottles. This
tap is separate from Homebrew/homebrew-core; no core-listing claim is made.

The release currently does not package `zed-gitops`; the formula does not claim
to install it. Git is a runtime dependency. Optional VCS providers may need their
own tools. If another application owns a command named `zed`, do not force a
link or overwrite it; inspect the conflict first.

```sh
brew update
brew upgrade oresoftware/tap/zed-cli
brew uninstall oresoftware/tap/zed-cli
```

The CI matrix exercises checksum-verified installation, command smoke tests,
reinstallation and uninstall on native ARM64/x86-64 macOS/Linux runners. See the
exact commit's workflow results rather than assuming tests passed from this file.

To publish an update, review the upstream release and its asset digests, update
all four versioned URLs and checksums together, and merge a tested pull request.
Never substitute a moving `latest` URL or disable checksum verification.

## Existing formulae

The historical `dpm` formula is retained unchanged, including its migration
notice. No unrelated formula is removed or overwritten.

## Visibility

This repository and everything committed here are public. Private packages,
private source, credentials and private build artifacts do not belong in this tap.
