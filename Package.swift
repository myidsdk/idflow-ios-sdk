// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "IDFlow",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "IDFlow", targets: ["IDFlow"])
    ],
    targets: [
        .binaryTarget(
            name: "IDFlow",
            url: "https://github.com/myidsdk/idflow-ios-sdk/releases/download/1.0.10/IDFlow.xcframework.zip",
            checksum: "4334860b55a24a1d71aa0547317c58fe42b23aa277c7312250b9f6dcbaa97247"
        )
    ]
)
