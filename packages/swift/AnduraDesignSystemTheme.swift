import SwiftUI

private struct AnduraDesignSystemEnvironmentKey: EnvironmentKey {
    static let defaultValue = AnduraDesignSystems.defaultSystem
}

public extension EnvironmentValues {
    var anduraDesignSystem: AnduraDesignSystem {
        get { self[AnduraDesignSystemEnvironmentKey.self] }
        set { self[AnduraDesignSystemEnvironmentKey.self] = newValue }
    }
}

public struct AnduraDesignSystemModifier: ViewModifier {
    public let system: AnduraDesignSystem
    public init(_ system: AnduraDesignSystem) { self.system = system }

    public func body(content: Content) -> some View {
        content
            .environment(\.anduraDesignSystem, system)
            .tint(Color(anduraARGB: system.accent))
            .foregroundStyle(Color(anduraARGB: system.foreground))
            .background(Color(anduraARGB: system.background))
            .preferredColorScheme(system.nativeDark ? .dark : .light)
    }
}

public extension View {
    /// Applies one of the 151 normalized Open Design systems to a subtree.
    func anduraDesignSystem(_ system: AnduraDesignSystem) -> some View {
        modifier(AnduraDesignSystemModifier(system))
    }

    func anduraDesignSystem(_ id: String) -> some View {
        anduraDesignSystem(AnduraDesignSystems.byID(id))
    }
}
