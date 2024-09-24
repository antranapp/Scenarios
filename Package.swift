// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Scenarios",
    platforms: [
        .iOS(.v13),
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
            dependencies: []
        ),
        .testTarget(
            name: "ScenariosTests",
            dependencies: ["Scenarios"]
        ),
    ]
)
