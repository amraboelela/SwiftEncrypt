// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftEncrypt",
    products: [
        .library(name: "SwiftEncrypt", targets: ["SwiftEncrypt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/amraboelela/CommonCrypto", .branch("master")),
        
    ],
    targets: [
        .target(
            name: "SwiftEncrypt",
            dependencies: ["CommonCrypto"]),
        .testTarget(name: "SwiftEncryptTests", dependencies: ["SwiftEncrypt"]),
    ]
)
