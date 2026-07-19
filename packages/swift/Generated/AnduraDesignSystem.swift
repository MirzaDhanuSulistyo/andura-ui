// GENERATED FILE - DO NOT EDIT.
import SwiftUI

public struct AnduraDesignSystem: Identifiable, Hashable, Sendable {
    public let id: String; public let name: String; public let category: String; public let description: String
    public let nativeDark: Bool
    public let background: UInt32; public let surface: UInt32; public let surfaceWarm: UInt32
    public let foreground: UInt32; public let foregroundSecondary: UInt32; public let muted: UInt32; public let border: UInt32
    public let accent: UInt32; public let accentOn: UInt32; public let success: UInt32; public let warning: UInt32; public let danger: UInt32
    public let fontDisplay: String; public let fontBody: String; public let textBase: Double
    public let radiusSm: Double; public let radiusMd: Double; public let radiusLg: Double; public let radiusPill: Double
    public let space1: Double; public let space2: Double; public let space3: Double; public let space4: Double; public let space6: Double; public let space8: Double
    public let motionFastMs: Int; public let motionBaseMs: Int; public let containerMax: Double
    public let componentGroups: [String]; public let sourceClassCount: Int
}

public extension Color {
    init(anduraARGB value: UInt32) {
        self.init(.sRGB, red: Double((value >> 16) & 255) / 255, green: Double((value >> 8) & 255) / 255, blue: Double(value & 255) / 255, opacity: Double((value >> 24) & 255) / 255)
    }
}
