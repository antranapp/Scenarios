// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Scenarios",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Scenarios",
            targets: ["Scenarios"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Scenarios",
            dependencies: [
                "MovableWindow",
            ]
        ),
        .target(
            name: "MovableWindow",
            dependencies: []
        ),
        .testTarget(
            name: "ScenariosTests",
            dependencies: ["Scenarios"]
        ),
    ]
)
