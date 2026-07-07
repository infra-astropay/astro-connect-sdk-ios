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
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.15/AstroConnectSDK-1.0.15.zip",
            checksum: "cc45cbf256e2c619254447487dd37f5fea76ce560e641ba94bf747cce45fb4ec"
        ),
        .binaryTarget(
            name: "AstroConnectSDKNativeKYC",
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.15/AstroConnectSDKNativeKYC-1.0.15.zip",
            checksum: "2129b49c0fd86d1a1ed170d8aa3aeb660f603da3566e3eaf8b5782eacede2fe3"
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
