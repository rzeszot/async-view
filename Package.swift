// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AsyncView",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "AsyncView",
            targets: [
                "AsyncView",
            ]
        ),
    ],
    targets: [
        .target(
            name: "AsyncView"
        ),
        .testTarget(
            name: "AsyncViewTests",
            dependencies: [
                "AsyncView",
            ]
        ),
    ]
)
