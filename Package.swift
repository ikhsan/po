// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "po",
    targets: [
        Target(name: "po", dependencies: ["poCore"]),
        Target(name: "poCore")
    ],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/ikhsan/Kitura-StencilTemplateEngine.git", majorVersion: 1, minor: 9),
    ]
)
