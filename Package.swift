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
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.10/AstroConnectSDK-1.0.10.zip",
            checksum: "b011055721e1ac6a9575261deff6393e646c47030ff6e90cc81e887bc3728a62"
        )
    ]
)
