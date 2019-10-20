// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SearchQueryParser",
    products: [
        .library(
            name: "SearchQueryParser",
            targets: ["SearchQueryParser"]),
    ],
    targets: [
        .target(
            name: "SearchQueryParser",
            dependencies: []),
        .testTarget(
            name: "SearchQueryParserTests",
            dependencies: ["SearchQueryParser"]),
    ]
)
