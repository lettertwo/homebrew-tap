class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "5b658822e837d16428fa6c700f22add1ef32fc569152ce2570d8799c15602bd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "3b8c5f18e96b3a944e7d642e882bf68343423fa0cd663517a8685ea5e7563ca6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "babfe31a3ded2b92934481e392546480543ef7468a42eebb0f92e37ef3cb9676"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2cf587ae93ac2da410b89fe0f7edbabb032013983ea583e3ea52ee3b8f1d0348"
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
