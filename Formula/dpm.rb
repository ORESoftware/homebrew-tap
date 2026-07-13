class Dpm < Formula
  deprecate! date: "2026-07-13", because: "moved to the declarative-migrations org — use `brew install declarative-migrations/tap/dpm`"
  desc "Declarative, ORM-agnostic Postgres schema migration (diff two databases)"
  homepage "https://github.com/declarative-migrations/declarative-postgres-migrate.rs"
  url "https://github.com/declarative-migrations/declarative-postgres-migrate.rs/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "368893c69f8a15cdd4026808acc621f8e30f78f96f824898a5cf6b3e567cf06d"
  license "MIT"
  head "https://github.com/declarative-migrations/declarative-postgres-migrate.rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install ".cli-flags.toml"
  end

  test do
    assert_match "dpm", shell_output("#{bin}/dpm version")
    assert_match "declarative postgres migrate", shell_output("#{bin}/dpm help")
  end
end
