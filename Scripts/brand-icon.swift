// Renders the rebrand's neutral placeholder app icon (REBRAND.md): the SF Symbol "display", white,
// on a solid slate square, 1024x1024, to the path given (Packaging/BrandIcon.png).
// Not Sill's logo, on purpose. Run: swift Scripts/brand-icon.swift Packaging/BrandIcon.png
import AppKit

let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "Packaging/BrandIcon.png"
let side = 1024
guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: side, pixelsHigh: side, bitsPerSample: 8,
                                 samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
                                 bytesPerRow: 0, bitsPerPixel: 0) else { fatalError("no bitmap") }
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
NSColor(srgbRed: 0.24, green: 0.27, blue: 0.32, alpha: 1).setFill()
NSRect(x: 0, y: 0, width: side, height: side).fill()
let config = NSImage.SymbolConfiguration(pointSize: 520, weight: .regular)
    .applying(NSImage.SymbolConfiguration(paletteColors: [.white]))
guard let symbol = NSImage(systemSymbolName: "display", accessibilityDescription: nil)?.withSymbolConfiguration(config)
else { fatalError("no SF Symbol 'display'") }
let s = symbol.size
symbol.draw(in: NSRect(x: (CGFloat(side) - s.width) / 2, y: (CGFloat(side) - s.height) / 2, width: s.width, height: s.height))
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
print("wrote \(out) (\(Int(s.width))x\(Int(s.height)) symbol)")
