class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.5.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "dbc095a477e8ce4e29a22c2e6898eda8baee97562216ad1c97a2430a0911604e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.5.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "f66b760a7ea02060d765b1c09db368d1d86c68bb55882e13d3ee169c66ed1539"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.5.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ae26a143479178e75cee8260da8e0728066faf5b18bb150cc73c2c50b5d7393"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.5.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef9e7e9b26f40d1824ac7b530f1fcf2e5303a89e982b164e3b6fb0cbd523bd3f"
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
    # Install man page and shell completions bundled in the release archive.
    man1.install "git-workon.1"
    bash_completion.install "git-workon.bash" => "git-workon"
    zsh_completion.install  "_git-workon"
    fish_completion.install "git-workon.fish"

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
