class GitWorkon < Formula
  desc "A git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.1.1/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "63a6c8b72651b2166fbd25b2c377669cc9a756391ed7dbb51fd0b643439ce7bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.1.1/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "39682cea01ad336ce0d92e13ac231634dec1023e1f02d0d4919171d6b5fd0377"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.1.1/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f890dc91a1f3b0444cd6f3ce5f344fdcf4176fd71d262d04b072b0eb5866e694"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.1.1/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a21e84a424dd65baa3ab14fc66df15d027925a52f8980148a0a6f414d2503ba4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "git-workon" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-workon" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-workon" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-workon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
