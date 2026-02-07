// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ModalPresenterDemo",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "ModalPresenterDemo",
            dependencies: [
                .product(name: "UsefulThingsSwiftUI", package: "UsefulThingsSwiftUI")
            ]
        )
    ]
)
