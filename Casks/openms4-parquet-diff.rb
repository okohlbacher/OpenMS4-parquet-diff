cask "openms4-parquet-diff" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.2,682f7086ebe9"
  sha256 arm:   "f3962947c95dfe742e232f86b45392ae2058b9718bdbf57b29b98c756584c867",
         intel: "8dfdb9020a40fa57c8eb1a6f5a3c213aef21923082da2f080cb0d7a28a94db24"

  url "https://github.com/okohlbacher/OpenMS4-parquet-diff/releases/download/" \
      "parquet-diff-v#{version.csv.first}/OpenMS4-parquet-diff-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 parquet-diff tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-parquet-diff"

  disable! date:    "2026-09-14",
           because: "was built against openms4-core 4.0.0-ci.2, and the tap now serves a binary-incompatible newer Core"

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
