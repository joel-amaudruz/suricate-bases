// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Vapor_App",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(
            url: "https://github.com/vapor/vapor.git",
            from: "4.115.0"
        ),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(
            url: "https://github.com/apple/swift-nio.git",
            from: "2.65.0"
        ),
        .package(
            url: "https://github.com/aus-der-technik/SwiftyNats.git",
            from: "2.2.0"
        ),
        .package(
            url: "https://github.com/vapor/postgres-nio",
            from: "1.19.1"
        ),
        .package(
            url: "https://github.com/vapor/fluent.git",
            from: "4.11.0"
        ),
        .package(
            url: "https://github.com/vapor/fluent-postgres-driver.git",
            from: "2.9.0"
        ),
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            from: "6.0.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "Vapor_App",
            dependencies: [
                .product(
                    name: "Vapor",
                    package: "vapor"
                ),
                .product(
                    name: "NIOCore",
                    package: "swift-nio"
                ),
                .product(
                    name: "NIOPosix",
                    package: "swift-nio"
                ),
                .product(
                    name: "SwiftyNats",
                    package: "SwiftyNats"
                ),
                .product(
                    name: "PostgresNIO",
                    package: "postgres-nio"
                ),
                .product(
                    name: "Fluent",
                    package: "fluent"
                ),
                .product(
                    name: "FluentPostgresDriver",
                    package: "fluent-postgres-driver"
                ),
                .product(
                    name: "RxSwift",
                    package: "RxSwift"
                ),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "Vapor_AppTests",
            dependencies: [
                .target(
                    name: "Vapor_App"
                ),
                .product(
                    name: "VaporTesting",
                    package: "vapor"
                ),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
