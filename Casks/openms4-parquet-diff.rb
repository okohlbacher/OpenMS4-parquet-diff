cask "openms4-parquet-diff" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.5,70bfad287412"
  sha256 arm:   "375b114738ba1e6440054acec15e0d139597424a61259d68774093fbab153ed3",
         intel: "ec6b1e257e18bca11c627952df0fae4bde319e9e8e75c3653782697dc65b5b81"

  url "https://github.com/okohlbacher/OpenMS4-parquet-diff/releases/download/" \
      "parquet-diff-v#{version.csv.first}/OpenMS4-parquet-diff-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 parquet-diff tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-parquet-diff"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-parquet-diff-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/ParquetDiff"

  # libOpenMS has no versioned name, so a payload only runs with the Core it was built against.
  preflight do
    config = "#{HOMEBREW_PREFIX}/opt/openms4-core/lib/cmake/OpenMS/OpenMSConfig.cmake"
    core = File.exist?(config) ? File.read(config)[/set\(OpenMS_SOURCE_REVISION "([0-9a-f]{40})"\)/, 1] : nil
    next if core == "eb58e981d7e0864634b59230874a56a1512369f7"

    raise Cask::CaskError, "openms4-parquet-diff #{version.csv.first} was built against openms4-core eb58e981d7e0, " \
                           "but the installed openms4-core is #{core&.slice(0, 12) || "unknown"}. " \
                           "Install the openms4-parquet-diff release built for the installed Core."
  end

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
