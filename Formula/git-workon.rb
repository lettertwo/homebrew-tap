class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.13.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.2/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "e81d236d33237000a1f1963e14e9cf5400ed91a1d7f0a8fbc3a19ffefedee445"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.2/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "24046201c42cf0093225cbe703adf26da516a2c53e21bae914f7155770c94f15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.2/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a4001fb6a4874578894ec1fa2610837e92e94fd8bc91657c4f156e647f5498e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.2/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e182cbf9e0d26ecd1363a07f98fadff16550c8c4f1c9de874e9eba5c8dc6b6d4"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "git-workon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-workon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-workon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-workon"
    end

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
