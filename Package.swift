// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "ContextMenuSwift",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "ContextMenuSwift", targets: ["ContextMenuSwift"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ContextMenuSwift",
            dependencies: []
        )
    ]
)
