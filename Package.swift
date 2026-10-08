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
            url: "https://github.com/myidsdk/idflow-ios-sdk/releases/download/1.0.9/IDFlow.xcframework.zip",
            checksum: "258e5f52f38f381cab615e8d77d51879942d0c7c5616926c1d1b96789af04c08"
        )
    ]
)
