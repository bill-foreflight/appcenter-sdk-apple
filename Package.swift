// swift-tools-version:5.0

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import PackageDescription

let package = Package(
    name: "AppCenter",
    platforms: [
        .iOS(.v9),
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
            targets: ["AppCenterCrashes"])
    ],
    dependencies: [
        .package(name: "PLCrashReporter", url: "https://github.com/bill-foreflight/plcrashreporter.git", .revision("09344c9efd52a6b80f6b44273a6601a01d7b1435")),
    ],
    targets: [
        .target(
            name: "AppCenter",
            path: "AppCenter/AppCenter",
            exclude: ["Support"],
            cSettings: [
                .define("APP_CENTER_C_VERSION", to:"\"4.1.0\""),
                .define("APP_CENTER_C_BUILD", to:"\"1\""),
                .headerSearchPath("**"),
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("sqlite3"),
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
            dependencies: ["AppCenter", "CrashReporter"],
            path: "AppCenterCrashes/AppCenterCrashes",
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
        )
    ]
)
