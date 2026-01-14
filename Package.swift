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
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.5/AstroConnectSDK-1.0.5.zip",
            checksum: "529aad7b1baa6b5503cd2ac8dd1cd30f7426271f929405c695a027df32d0c40d"
        )
    ]
)
