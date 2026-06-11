class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.7.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "56618b2df088a4e8fca849355afda97b6a2817a12a1456f9f90cdfee7480126c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.7.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "2a0cb5e8e3d8a28ec193b04ed38cf9efbf12a2e824fdbf603e7bf070767bb864"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.7.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f6d273e1cd3c73660b76c2fe18055384a9fcd1ce81f9a54df3ca2b0f05dfdf26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.7.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4738115643e38c638ae705ccdcbf1d68eb3e202addc9ef00e9831cba511939e"
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
