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

    public init(
        id: String, name: String, category: String, description: String,
        nativeDark: Bool,
        background: UInt32, surface: UInt32, surfaceWarm: UInt32,
        foreground: UInt32, foregroundSecondary: UInt32, muted: UInt32, border: UInt32,
        accent: UInt32, accentOn: UInt32, success: UInt32, warning: UInt32, danger: UInt32,
        fontDisplay: String, fontBody: String, textBase: Double,
        radiusSm: Double, radiusMd: Double, radiusLg: Double, radiusPill: Double,
        space1: Double, space2: Double, space3: Double, space4: Double, space6: Double, space8: Double,
        motionFastMs: Int, motionBaseMs: Int, containerMax: Double,
        componentGroups: [String], sourceClassCount: Int
    ) {
        self.id = id; self.name = name; self.category = category; self.description = description
        self.nativeDark = nativeDark
        self.background = background; self.surface = surface; self.surfaceWarm = surfaceWarm
        self.foreground = foreground; self.foregroundSecondary = foregroundSecondary; self.muted = muted; self.border = border
        self.accent = accent; self.accentOn = accentOn; self.success = success; self.warning = warning; self.danger = danger
        self.fontDisplay = fontDisplay; self.fontBody = fontBody; self.textBase = textBase
        self.radiusSm = radiusSm; self.radiusMd = radiusMd; self.radiusLg = radiusLg; self.radiusPill = radiusPill
        self.space1 = space1; self.space2 = space2; self.space3 = space3; self.space4 = space4; self.space6 = space6; self.space8 = space8
        self.motionFastMs = motionFastMs; self.motionBaseMs = motionBaseMs; self.containerMax = containerMax
        self.componentGroups = componentGroups; self.sourceClassCount = sourceClassCount
    }

    public func copyWith(
        id: String? = nil, name: String? = nil, category: String? = nil, description: String? = nil,
        nativeDark: Bool? = nil,
        background: UInt32? = nil, surface: UInt32? = nil, surfaceWarm: UInt32? = nil,
        foreground: UInt32? = nil, foregroundSecondary: UInt32? = nil, muted: UInt32? = nil, border: UInt32? = nil,
        accent: UInt32? = nil, accentOn: UInt32? = nil, success: UInt32? = nil, warning: UInt32? = nil, danger: UInt32? = nil,
        fontDisplay: String? = nil, fontBody: String? = nil, textBase: Double? = nil,
        radiusSm: Double? = nil, radiusMd: Double? = nil, radiusLg: Double? = nil, radiusPill: Double? = nil,
        space1: Double? = nil, space2: Double? = nil, space3: Double? = nil, space4: Double? = nil, space6: Double? = nil, space8: Double? = nil,
        motionFastMs: Int? = nil, motionBaseMs: Int? = nil, containerMax: Double? = nil,
        componentGroups: [String]? = nil, sourceClassCount: Int? = nil
    ) -> AnduraDesignSystem {
        AnduraDesignSystem(
            id: id ?? self.id, name: name ?? self.name, category: category ?? self.category, description: description ?? self.description,
            nativeDark: nativeDark ?? self.nativeDark,
            background: background ?? self.background, surface: surface ?? self.surface, surfaceWarm: surfaceWarm ?? self.surfaceWarm,
            foreground: foreground ?? self.foreground, foregroundSecondary: foregroundSecondary ?? self.foregroundSecondary,
            muted: muted ?? self.muted, border: border ?? self.border,
            accent: accent ?? self.accent, accentOn: accentOn ?? self.accentOn, success: success ?? self.success,
            warning: warning ?? self.warning, danger: danger ?? self.danger,
            fontDisplay: fontDisplay ?? self.fontDisplay, fontBody: fontBody ?? self.fontBody, textBase: textBase ?? self.textBase,
            radiusSm: radiusSm ?? self.radiusSm, radiusMd: radiusMd ?? self.radiusMd,
            radiusLg: radiusLg ?? self.radiusLg, radiusPill: radiusPill ?? self.radiusPill,
            space1: space1 ?? self.space1, space2: space2 ?? self.space2, space3: space3 ?? self.space3,
            space4: space4 ?? self.space4, space6: space6 ?? self.space6, space8: space8 ?? self.space8,
            motionFastMs: motionFastMs ?? self.motionFastMs, motionBaseMs: motionBaseMs ?? self.motionBaseMs,
            containerMax: containerMax ?? self.containerMax,
            componentGroups: componentGroups ?? self.componentGroups, sourceClassCount: sourceClassCount ?? self.sourceClassCount
        )
    }
}

public extension Color {
    init(anduraARGB value: UInt32) {
        self.init(.sRGB, red: Double((value >> 16) & 255) / 255, green: Double((value >> 8) & 255) / 255, blue: Double(value & 255) / 255, opacity: Double((value >> 24) & 255) / 255)
    }
}
