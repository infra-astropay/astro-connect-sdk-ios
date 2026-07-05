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
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.15-alpha.1/AstroConnectSDK-1.0.15-alpha.1.zip",
            checksum: "c0ac1c7ba88c5242b86f0331cf41b6835eadef322d8533707d586d93b6b6a686"
        ),
        .binaryTarget(
            name: "AstroConnectSDKNativeKYC",
            url: "https://github.com/infra-astropay/astro-connect-sdk-ios/releases/download/v1.0.15-alpha.1/AstroConnectSDKNativeKYC-1.0.15-alpha.1.zip",
            checksum: "f013b229237da8f610739041aabf40e04daead64ef4c1749dbf17d0af3da215c"
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
