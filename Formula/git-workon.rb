class GitWorkon < Formula
  desc "Git plugin for managing worktrees"
  homepage "https://github.com/lettertwo/git-workon"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.12.0/git-workon-aarch64-apple-darwin.tar.xz"
      sha256 "ff178e60589b3416092652d5e64d24cd98dee13d588d01b1122b13a04fa09285"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.12.0/git-workon-x86_64-apple-darwin.tar.xz"
      sha256 "1d1f33521b6352db3ffe22636ac1a0770e3ccfc725ac87d25c31057622c06521"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.12.0/git-workon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "438e5e1bc33cb9243bb1215c18a744ed463435a29e444f6be737e4044d2f9e84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lettertwo/git-workon/releases/download/git-workon-v0.12.0/git-workon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "953dcd71def83d513f5f765b6845cb56affc900edc776c8756693a12b5c41190"
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
