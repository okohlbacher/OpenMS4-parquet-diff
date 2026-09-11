cask "openms4-parquet-diff" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.1,771b7e6139d3"
  sha256 arm:   "f207f0f56626b5b5c901783820d77eda799c6693a3c4b288a513697ea7392267",
         intel: "a1e57d44e2e50ade5a1b99ff827150aa1a2557357f3cb8e881558fbed3d83c30"

  url "https://github.com/okohlbacher/OpenMS4-parquet-diff/releases/download/" \
      "parquet-diff-v#{version.csv.first}/OpenMS4-parquet-diff-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 parquet-diff tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-parquet-diff"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-parquet-diff-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/ParquetDiff"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
