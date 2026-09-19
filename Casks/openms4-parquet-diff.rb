cask "openms4-parquet-diff" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.6,6eff01573a1a"
  sha256 arm:   "094edf046c50b2e0f5e1704c10dcc328fa4cfa89ed6e784d7c00b3de1519918e",
         intel: "deb83050c55dbacbc072793710b1586ee21ed8d620481e36512c6a32b8555a83"

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
    next if core == "7d90cec8718d28518527acc10b495550f106de26"

    raise Cask::CaskError, "openms4-parquet-diff #{version.csv.first} was built against openms4-core 7d90cec8718d, " \
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
