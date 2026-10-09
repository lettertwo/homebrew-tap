class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.15.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "10d904645e9722709b6f9996cb400ccdbda40b4b8c8e758b6072c0e0f62f0b31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.15.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "1938d7c16fbd3fa50321835b980ff20b514b13b88ff93ff7bc575a74359777d5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.15.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd7e904e6e223912f14d3780da0415c43b886117b1d527f2d1fecf9fe0c8809a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.15.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18b027f15c83e60e2f96fb3a6df892da6df0435b74ff72cd30cc58d1a4e653c6"
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
