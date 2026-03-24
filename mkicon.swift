import Cocoa

let emoji = "⏰"
let sizes = [1024, 512, 256, 128, 64, 32, 16]
let iconsetPath = "/tmp/jontime.iconset"

try? FileManager.default.removeItem(atPath: iconsetPath)
try! FileManager.default.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)

for size in sizes {
    for scale in [1, 2] {
        let px = size * scale
        if px > 1024 { continue }

        let img = NSImage(size: NSSize(width: px, height: px))
        img.lockFocus()

        let font = NSFont.systemFont(ofSize: CGFloat(px) * 0.85)
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let str = NSAttributedString(string: emoji, attributes: attrs)
        let strSize = str.size()
        let point = NSPoint(
            x: (CGFloat(px) - strSize.width) / 2,
            y: (CGFloat(px) - strSize.height) / 2
        )
        str.draw(at: point)
        img.unlockFocus()

        let tiff = img.tiffRepresentation!
        let bitmap = NSBitmapImageRep(data: tiff)!
        let png = bitmap.representation(using: .png, properties: [:])!

        let name = scale == 1
            ? "icon_\(size)x\(size).png"
            : "icon_\(size)x\(size)@2x.png"
        let path = iconsetPath + "/" + name
        try! png.write(to: URL(fileURLWithPath: path))
    }
}

print("Iconset created at \(iconsetPath)")
