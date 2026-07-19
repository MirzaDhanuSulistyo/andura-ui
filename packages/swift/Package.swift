// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AnduraUI",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [.library(name: "AnduraUI", targets: ["AnduraUI"])],
    targets: [.target(name: "AnduraUI", path: ".", exclude: ["Package.swift"])]
)
