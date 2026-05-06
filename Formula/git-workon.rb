class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.2.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "6187e4d1c33ee4939fd65822d37adce4975d1f176860ce865d7c35eff3d1be7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.2.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "29586b332ac172368daee8c7b3a08b84037b195433d9577c57370ae4c3c6f118"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.2.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7cec1beddfe8ecae2ca440f01313b125d9e5104f67a5502223188bc7ead0745"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.2.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "34cd609bf0286a8b630f8ce5f7e41ced930ea32b97a58832d81b4fb7623a8f22"
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
