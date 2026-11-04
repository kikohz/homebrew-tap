cask "cellglide" do
  version "1.3.1"
  sha256 "6764b1f10bac4236ee228467017d173d422f6c6690eaa3bba53164dca7667e56"

  url "https://cellglide.com/downloads/CellGlide-#{version}-macOS-universal.zip"
  name "CellGlide"
  desc "Use an iPhone's cellular connection over USB or wirelessly"
  homepage "https://cellglide.com/"

  livecheck do
    url "https://cellglide.com/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: :ventura

  app "CellGlide.app"

  # Give the network back and remove the background helper before the app goes away.
  uninstall early_script: {
              executable:   "#{appdir}/CellGlide.app/Contents/MacOS/CellProxyMac",
              args:         ["--stop-network"],
              must_succeed: false,
            },
            launchctl:    "com.kikohz.cellproxy.mac.usb",
            quit:         "com.kikohz.cellproxy.mac",
            script:       {
              executable:   "#{appdir}/CellGlide.app/Contents/MacOS/CellProxyMac",
              args:         ["--unregister-helper"],
              must_succeed: false,
            }

  zap trash: [
    "~/Library/Application Support/CellGlide",
    "~/Library/Application Support/com.kikohz.cellproxy.mac",
    "~/Library/Caches/com.kikohz.cellproxy.mac",
    "~/Library/HTTPStorages/com.kikohz.cellproxy.mac",
    "~/Library/Logs/CellGlide",
    "~/Library/Preferences/com.kikohz.cellproxy.mac.plist",
    "~/Library/Saved Application State/com.kikohz.cellproxy.mac.savedState",
    "~/Library/WebKit/com.kikohz.cellproxy.mac",
  ]
end
