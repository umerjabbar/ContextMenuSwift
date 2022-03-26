// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ContextMenuSwift",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "ContextMenuSwift", targets: ["ContextMenuSwift"])
    ],
    targets: [
        .target(
            name: "ContextMenuSwift",
            path: "Sources"
        )
    ],
swiftLanguageVersions: [.v5]
)
