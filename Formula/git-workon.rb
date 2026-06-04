class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.6.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "2386b4a808140f1923d26d2687e4048787a07b13627a4a4ea28e5bffb4f68461"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.6.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "b85620154b901072a83374f8bd9c101dcd5a55616239b8fa025fa04d7700e8ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.6.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b5c695d9be1bda89da79beef90008e27cabd32280ea2c41863596cb8139adbdd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.6.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4784e9653ce6160e288e11ab509ea5fb5b8cca71da5d497e7a9ebcd4592f1cf6"
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
