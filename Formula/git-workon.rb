class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.1/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "003222a7fadb669cd919ab1d3e867950f6ea7902a13cb319938fb677e6149631"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.1/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "69941a717709a7ee629f2064279455fe48aac64a60bf444fd4c4d98f353f9c11"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.1/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd2b7fb6240fc75a198325eedd49d8aa7250769696299c17f6b472af0c0960fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.13.1/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6ccf3ce4914d39fdbbab7533acd73444596fbf06d1ced789837a729f4b923989"
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
