class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.11.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "fe636509507c9bc02ef6c2b48f18d8023848f3d02034da4dd210d326ae793192"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.11.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "a3b2c35afc3738c1c892dc503defe472a4f84771d9643a99fa7820f0beaf5621"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.11.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a47d3fe61418b6264cf4c61bf3608a2e0bcf07617feb415289013dce31cdb5ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.11.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ce7bf044e1f4854014cb7cdb9026122e9d50efbcd5adbd9977836e2d03b05801"
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
