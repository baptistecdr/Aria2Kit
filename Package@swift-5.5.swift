// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "Aria2Kit",
        platforms: [.macOS(.v10_13),
                    .iOS(.v11),
                    .tvOS(.v11),
                    .watchOS(.v4)],
        products: [
            .library(
                    name: "Aria2Kit",
                    targets: ["Aria2Kit"]),
        ],
        dependencies: [
            .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", .revision("5.9.0")),
            .package(name: "AnyCodable", url: "https://github.com/Flight-School/AnyCodable", .revision("0.6.7")),
        ],
        targets: [
            .target(
                    name: "Aria2Kit",
                    dependencies: [
                        "Alamofire",
                        "AnyCodable"
                    ]),
            .testTarget(
                    name: "Aria2KitTests",
                    dependencies: ["Aria2Kit"],
                    resources: [.process("Resources")]
            ),
        ],
        swiftLanguageVersions: [.v5]
)
