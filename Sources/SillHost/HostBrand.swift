// Part of Sill (Apache-2.0, LICENSE); added in the rebrand (NOTICE, REBRAND.md).
import Foundation

/// The app's user-visible name and identity, read from the bundle's Info.plist, which
/// Scripts/make-app.sh writes from Packaging/Brand.env (the one place to rename the app). The bare
/// binaries (SillHost, .build/release/SillMenuBar) have no Info.plist and keep stock Sill's values.
///
/// Branding only: nothing on the wire (service type, ALPNs, pairing links, message formats) reads this.
package enum HostBrand {
    /// Stock Sill's bundle ID: an app with this ID (or none) keeps stock Sill's keychain names.
    package static let stockBundleID = "me.saffer.sill.mac"

    package static let name: String = info("CFBundleName") ?? "Sill"

    /// The phone apps the app's words point to ("Open … on your iPhone or iPad").
    package static let phoneApps: String = info("BrandPhoneApps") ?? "Sill"

    /// Whether the update check may ever ask a server (stock Sill: yes, GitHub; the rebrand: no).
    package static let updateCheckEnabled: Bool = (info("BrandUpdateCheck") ?? "1") != "0"

    /// The bundle ID when it is not stock Sill's, else nil.
    package static let rebrandedBundleID: String? = {
        guard let id = Bundle.main.bundleIdentifier, !id.isEmpty, id != stockBundleID,
              Bundle.main.bundleURL.pathExtension == "app" else { return nil }
        return id
    }()

    private static func info(_ key: String) -> String? {
        guard Bundle.main.bundleURL.pathExtension == "app",
              let v = Bundle.main.object(forInfoDictionaryKey: key) as? String, !v.isEmpty else { return nil }
        return v
    }
}
