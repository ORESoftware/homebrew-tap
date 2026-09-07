class ZedCli < Formula
  desc "Universal package manager backed by existing version-control hosts"
  homepage "https://github.com/zed-pkg/zed-cli"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/zed-pkg/zed-cli/releases/download/v0.3.0/zed-aarch64-apple-darwin.tar.gz"
      sha256 "234c1107dac9d1a417e554c94598584543866696b63429dffb855d6b36519bd0"
    end
    on_intel do
      url "https://github.com/zed-pkg/zed-cli/releases/download/v0.3.0/zed-x86_64-apple-darwin.tar.gz"
      sha256 "66264d5ffc17fc638f1f3fd9fead97b9a58ada322cd637d1d7b4642f8a0065a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zed-pkg/zed-cli/releases/download/v0.3.0/zed-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2fb51417aed2fcfede6e014b35907190f338a43099383ae4ae8b0435b0034caf"
    end
    on_intel do
      url "https://github.com/zed-pkg/zed-cli/releases/download/v0.3.0/zed-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f87576bc289e43ed647902527e7be70566445d2f1fd11249f067ab35547d4b8a"
    end
  end

  depends_on "git"

  def install
    bin.install "zed", "zed-binary"
  end

  def caveats
    <<~EOS
      This is the zed-pkg package manager, not the Zed editor.
      It installs the commands zed and zed-binary. Do not overwrite an existing
      editor-owned zed executable to resolve a naming conflict.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zed --version")
    assert_match version.to_s, shell_output("#{bin}/zed-binary --version")
    assert_match "Usage:", shell_output("#{bin}/zed --help")
  end
end
