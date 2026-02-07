import SwiftUI


#if os(macOS)
/// returns the SwiftUI Image from a given image file URL
public func imageFromUrl(url: URL) -> Image {
    return Image(nsImage: NSImage(contentsOf: url)!)
}

/// returns the SwiftUI Image from a given image file URL
public func imageFrom(filePath: String) -> Image {
    return Image(nsImage: NSImage(contentsOfFile: filePath)!)
}

#endif

#if os(iOS)
/// returns the SwiftUI Image from a given image file URL
public func imageFromUrl(url: URL) -> Image {
    return Image(uiImage: UIImage(contentsOfFile: url.path)!)
}

/// returns the SwiftUI Image from a given image file URL
public func imageFrom(filePath: String) -> Image {
    return Image(uiImage: UIImage(contentsOfFile: filePath)!)
}

#endif
