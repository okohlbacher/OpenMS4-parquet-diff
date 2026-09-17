cask "openms4-parquet-diff" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.4,1cd0b6b1e3c5"
  sha256 arm:   "a463f5b137ec312c81583af68506e3e2d7d21705009fa84de7f1821e960ca1fd",
         intel: "1ebf371cde50376fe0dee072bcc9fb33753247eeb3dd04e8fda12f4e3678994a"

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
    next if core == "84847138c0de67149601aaa860af7ac8e2e64534"

    raise Cask::CaskError, "openms4-parquet-diff #{version.csv.first} was built against openms4-core 84847138c0de, " \
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
