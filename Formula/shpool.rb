class Shpool < Formula
  desc "Lightweight persistent shell session manager"
  homepage "https://github.com/shell-pool/shpool"
  url "https://github.com/shell-pool/shpool/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "27addaae38f92933a495f0504f856b4d9f14e179d5cc4b115f77f76d95985df0"
  license "Apache-2.0"
  head "https://github.com/shell-pool/shpool.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install",
      "--locked",
      "--root", prefix,
      "--path", "shpool"
  end

  service do
    run [opt_bin/"shpool", "daemon"]
    keep_alive true
    log_path var/"log/shpool.log"
    error_log_path var/"log/shpool.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shpool version")
  end
end
