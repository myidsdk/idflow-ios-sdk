# IDFlow iOS SDK

Requirements: iOS 14.0+, Swift 5.8+.

## Installation

### Swift Package Manager

Available from version 1.0.9.

In Xcode: **File → Add Package Dependencies…**, enter

```
https://github.com/myidsdk/idflow-ios-sdk
```

and choose **Up to Next Major Version** from `1.0.9`.

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/myidsdk/idflow-ios-sdk", from: "1.0.9")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "IDFlow", package: "idflow-ios-sdk")
        ]
    )
]
```

### CocoaPods

```ruby
pod 'IDFlow', '~> 1.0.9'
```

Versions before 1.0.9 are available through CocoaPods only.

Use a version from the CocoaPods trunk as shown above. Starting with 1.0.9 the binary is no longer stored in the git repository, so `pod 'IDFlow', :git => '...'` without a version tag will not work.

## Releasing

1. Place the new `IDFlow.xcframework` (built with the release version) in the repository root. It is git-ignored.
2. Run `scripts/prepare-release.sh <version>`. It creates `IDFlow.xcframework.zip` and writes the version and checksum into `Package.swift` and `IDFlow.podspec`.
3. Follow the steps the script prints: commit, tag, push, create the GitHub Release with the zip attached, verify, then `pod trunk push`.

Never replace a release asset after its tag is published — SPM pins the checksum. Publish a new version instead.
