// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AstroConnectSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AstroConnectSDK",
            targets: ["AstroConnectSDK"]
        ),
        .library(
            name: "AstroConnectSDKNativeKYC",
            targets: ["AstroConnectSDKNativeKYC", "AstroConnectNativeKYCCafLink"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/combateafraude/caf-ios-sdk.git", exact: "7.0.0")
    ],
    targets: [
        .binaryTarget(
            name: "AstroConnectSDK",
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.16/AstroConnectSDK-1.0.16.zip",
            checksum: "082e71d0d447039f78e7a0e796faaac52a8d6eeb40e3e91e69c6a87bd51b8400"
        ),
        .binaryTarget(
            name: "AstroConnectSDKNativeKYC",
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.16/AstroConnectSDKNativeKYC-1.0.16.zip",
            checksum: "6379ae3031e45c91594ff93d0af06b6e41071670eb099e6ca44ea40a03dd2270"
        ),
        .target(
            name: "AstroConnectNativeKYCCafLink",
            dependencies: [
                .product(name: "CafSDK", package: "caf-ios-sdk")
            ],
            path: "Sources/AstroConnectNativeKYCCafLink"
        )
    ]
)
