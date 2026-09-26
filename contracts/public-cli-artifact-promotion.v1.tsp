namespace ORES.Homebrew;

enum CliName {
  oresStack: "ores-stack",
  bmscl: "bmscl",
  bmsclGleam: "bmscl-gleam",
  scintilla: "scintilla",
}

enum NativeTarget {
  macosArm64: "aarch64-apple-darwin",
  macosX8664: "x86_64-apple-darwin",
  linuxArm64: "aarch64-unknown-linux-gnu",
  linuxX8664: "x86_64-unknown-linux-gnu",
  windowsX8664: "x86_64-pc-windows-msvc",
}

model SourceIdentity {
  repository: string;
  tag: string;
  commit: string;
}

model PrivateArtifactIdentity {
  filename: string;
  sha256: string;
  target: NativeTarget;
}

model PublicArtifactIdentity {
  url: string;
  filename: string;
  sha256: string;
  public_access_verified: true;
}

model FormulaTarget {
  name: string;
  os: "macos";
  arch: "arm64" | "x86_64";
}

model CliArtifactPromotionReceiptV1 {
  schema_version: "ores.homebrew.cli-promotion/v1";
  cli: CliName;
  version: string;
  source: SourceIdentity;
  private_artifact: PrivateArtifactIdentity;
  public_artifact: PublicArtifactIdentity;
  formula: FormulaTarget;
  byte_identical: true;
}
