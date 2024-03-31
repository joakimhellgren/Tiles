// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Tiles",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Tiles", targets: ["Tiles"]),
    ],
    targets: [
        .target(name: "Tiles"),
        .testTarget(name: "TilesTests", dependencies: ["Tiles"]),
    ]
)
