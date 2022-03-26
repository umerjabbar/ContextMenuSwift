// swift-tools-version:5.3

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
            dependencies: []
        )
    ],
swiftLanguageVersions: [.v5]
)
