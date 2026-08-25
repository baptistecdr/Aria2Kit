// swift-tools-version: 6.1
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
            .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", .revision("5.12.0")),
        ],
        targets: [
            .target(
                    name: "Aria2Kit",
                    dependencies: [
                        "Alamofire"
                    ]),
            .testTarget(
                    name: "Aria2KitTests",
                    dependencies: ["Aria2Kit"],
                    resources: [.process("Resources")]
            ),
        ],
        swiftLanguageVersions: [.v5]
)
