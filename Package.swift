// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "IQKeyboardReturnManager",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "IQKeyboardReturnManager",
            targets: ["IQKeyboardReturnManager"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hackiftekhar/IQKeyboardCore.git", from: "1.0.5"),
    ],
    targets: [
        .target(name: "IQKeyboardReturnManager",
            dependencies: ["IQKeyboardCore"],
            path: "IQKeyboardReturnManager",
            resources: [
                .copy("Assets/PrivacyInfo.xcprivacy")
            ],
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        )
    ]
)
