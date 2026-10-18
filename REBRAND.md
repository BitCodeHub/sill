# Rebrand: Overlook (Sill for Mac, modified)

Overlook is the menu-bar half of Sill, renamed for Jimmy's own Macs. The phone
side is the stock Sill iPhone/iPad app or the "Macs" tab in Sage TV; both
connect because nothing on the wire changed.

## The one place to rename

`Packaging/Brand.env`:

| key | now | what it drives |
|---|---|---|
| `BRAND_NAME` | `Overlook` | app bundle name (`Overlook.app`), executable, CFBundleName/DisplayName, menu bar title, About, Quit/Relaunch items, every user-visible string, log folder `~/Library/Logs/Overlook/`, virtual display name |
| `BRAND_BUNDLE_ID` | `cloud.agentlumi.overlook.mac` | CFBundleIdentifier, defaults domain, TCC grants, keychain service `<id>.remote` |
| `BRAND_PHONE_APPS` | `Sill or Sage TV` | "Open … on your iPhone or iPad" wording |
| `BRAND_UPDATE_CHECK` | `0` | 0 = no update check, no request to any server |
| `BRAND_SIGN_IDENTITY` | Apple Development: Jimmy Lam (SHA-1 `CCB26D66…`) | codesign identity (keep stable: TCC grants follow it) |

`Scripts/make-app.sh` sources it and writes the values into the built
Info.plist; Swift reads them back at runtime through
`Sources/SillHost/HostBrand.swift` (`HostBrand.name`, `.phoneApps`,
`.updateCheckEnabled`, `.rebrandedBundleID`). Renaming = edit `BRAND_NAME`
(and `BRAND_BUNDLE_ID`), run `Scripts/make-app.sh --install`. (Changing the
bundle ID means macOS asks for Screen Recording / Accessibility / Local
Network again, and devices pair again.)

The bare binaries (`SillHost` CLI, `.build/release/SillMenuBar`) have no
Info.plist and keep stock Sill's names.

## Never changed (wire compatibility with stock Sill)

- Bonjour type `_sill._tcp` (Info.plist `NSBonjourServices` too), TXT keys `r`/`p`
- TLS 1.3 with pinned self-signed P-256 keys, ALPNs `sill/1` and `sill-pair/1`, server name `sill`
- `sill://pair` links, pairing code/proof formats, all message kinds and JSON
- Remote Access (Tailscale / port forward) behaviour, default remote port 7455
- `Sources/StreamProtocol/` is byte-for-byte main's.

## What changed besides names

- **Update check disabled.** Stock Sill asks `api.github.com/repos/Saffsanity/sill/releases/latest`
  once a day. With `BRAND_UPDATE_CHECK=0` the checker never schedules or sends a
  request (`UpdateChecker.canCheck`/`run()` guard) and Settings › General hides the
  Updates section. No other outbound calls exist in the app (no telemetry, no
  getsill.app calls; it only opens System Settings panes).
- **Own keychain identity.** The remote/home-door identity, trust list and Require
  pairing live under keychain service `cloud.agentlumi.overlook.mac.remote` (stock:
  `me.saffer.sill.remote`), so Overlook never reads or overwrites stock Sill.app's
  pairing and never triggers its keychain prompt. Devices pair with Overlook
  separately (same pairing flow).
- **Icon:** neutral placeholder, `Packaging/BrandIcon.png`, rendered from the SF
  Symbol "display" by `Scripts/brand-icon.swift`. Replace that PNG for a real icon.
- **Text pointing at the phone app** says "Sill or Sage TV".
- **Known leftovers saying "Sill":** messages the host sends *to the device*
  (e.g. "Update Sill on your iPad…", "Allow Accessibility for Sill on the Mac") are
  untouched host-core text, kept as stock; the update-available preview sample.

## Running beside stock Sill

Stock `Sill.app` stays installed. Run only one of the two at a time: both
advertise `_sill._tcp` under the Mac's name (the second becomes "Mac (2)"), and
both would try remote port 7455 if Remote Access is on in both. Overlook does
not launch at login unless turned on in Settings › General.
