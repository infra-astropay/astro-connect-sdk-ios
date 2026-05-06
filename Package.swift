// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AstroConnectSDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "AstroConnectSDK",
            targets: ["AstroConnectSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "AstroConnectSDK",
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.11/AstroConnectSDK-1.0.11.zip",
            checksum: "b859568dd4baff382caa8d1f5bb750e362ec55a57a51c5b5743b72445b2421f6"
        )
    ]
)
