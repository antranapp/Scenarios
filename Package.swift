// swift-tools-version:5.3
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
            dependencies: [],
            path: "Packages/Sources"
        ),
        .testTarget(
            name: "ScenariosTests",
            dependencies: ["Scenarios"],
            path: "Packages/Tests"
        ),
    ]
)
