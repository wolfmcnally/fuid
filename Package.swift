// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FUID",
    products: [
        .library(
            name: "FUID",
            targets: ["FUID"]),
    ],
    dependencies: [
        .package(url: "https://github.com/objecthub/swift-numberkit.git", .upToNextMajor(from: "2.6.0")),
    ],
    targets: [
        .target(
            name: "FUID",
            dependencies: [
                .product(name: "NumberKit", package: "swift-numberkit")
            ]),
        .testTarget(
            name: "FUIDTests",
            dependencies: [
                "FUID"
            ]),
    ]
)
