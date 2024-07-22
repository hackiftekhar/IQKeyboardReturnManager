// swift-tools-version:5.6

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
    targets: [
        .target(name: "IQKeyboardReturnManager",
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
