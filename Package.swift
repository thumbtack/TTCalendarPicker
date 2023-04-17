// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TTCalendarPicker",
    defaultLocalization: "en",
    platforms: [
            .iOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TTCalendarPicker",
            targets: ["TTCalendarPicker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/uber/ios-snapshot-test-case.git", from: "8.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TTCalendarPicker",
            dependencies: ["SnapKit"]),
        .testTarget(
            name: "TTCalendarPickerTests",
            dependencies: [
                "SnapKit",
                .product(name: "iOSSnapshotTestCase", package: "ios-snapshot-test-case"),
                "TTCalendarPicker",
                ]
            )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
