// swift-tools-version:5.3

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import PackageDescription

let package = Package(
    name: "AppCenter",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_10),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "AppCenterAnalytics",
            type: .static,
            targets: ["AppCenterAnalytics"]),
        .library(
            name: "AppCenterCrashes",
            type: .static,
            targets: ["AppCenterCrashes"]),
        .library(
            name: "AppCenterDistribute",
            type: .static,
            targets: ["AppCenterDistribute"]),
    ],
    dependencies: [
        .package(name: "PLCrashReporter", url: "https://github.com/bill-foreflight/plcrashreporter.git", .revision("09344c9efd52a6b80f6b44273a6601a01d7b1435")),
        .package(
            name: "SpatialiteSqlite3Proj",
            url: "git@github.com:foreflight/ffm-spatialite-sqlite-proj.git",
            .upToNextMinor(from: "1.0.5")
        )

    ],
    targets: [
        .target(
            name: "AppCenter",
            dependencies: [
                .product(name: "CSQLite3", package: "SpatialiteSqlite3Proj")
            ],
            path: "AppCenter/AppCenter",
            exclude: ["Support"],
            cSettings: [
                .define("APP_CENTER_C_VERSION", to:"\"4.0.1\""),
                .define("APP_CENTER_C_BUILD", to:"\"1\""),
                .headerSearchPath("**"),
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedFramework("Foundation"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("CoreTelephony", .when(platforms: [.iOS, .macOS])),
            ]
        ),
        .target(
            name: "AppCenterAnalytics",
            dependencies: ["AppCenter"],
            path: "AppCenterAnalytics/AppCenterAnalytics",
            exclude: ["Support"],
            cSettings: [
                .headerSearchPath("**"),
                .headerSearchPath("../../AppCenter/AppCenter/**"),
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
            ]
        ),
        .target(
            name: "AppCenterCrashes",
            dependencies: [
                "AppCenter",
                .product(name: "CrashReporter", package: "PLCrashReporter"),
            ],
            path: "AppCenterCrashes/AppCenterCrashes",
            exclude: ["Support", "Internals/MSACCrashesBufferedLog.hpp"],
            cSettings: [
                .headerSearchPath("**"),
                .headerSearchPath("../../AppCenter/AppCenter/**"),
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
            ]
        ),
        .target(
            name: "AppCenterDistribute",
            dependencies: ["AppCenter"],
            path: "AppCenterDistribute/AppCenterDistribute",
            exclude: ["Support"],
            resources: [
                .process("Resources/AppCenterDistribute.strings"),
            ],
            cSettings: [
                .headerSearchPath("**"),
                .headerSearchPath("../../AppCenter/AppCenter/**"),
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("SafariServices", .when(platforms: [.iOS])),
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
            ]
        )
    ]
)
