import SwiftUI

public enum AnduraIntent: Sendable { case neutral, info, success, warning, danger }

private extension AnduraIntent {
    func color(_ system: AnduraDesignSystem) -> Color {
        switch self {
        case .neutral: Color(anduraARGB: system.muted)
        case .info: Color(anduraARGB: system.accent)
        case .success: Color(anduraARGB: system.success)
        case .warning: Color(anduraARGB: system.warning)
        case .danger: Color(anduraARGB: system.danger)
        }
    }
}

public struct AnduraSectionHeader<Action: View>: View {
    public let title: String
    private let action: Action
    public init(_ title: String, @ViewBuilder action: () -> Action) { self.title = title; self.action = action() }
    public var body: some View { HStack { Text(title).font(.headline); Spacer(); action } }
}

public extension AnduraSectionHeader where Action == EmptyView {
    init(_ title: String) { self.init(title) { EmptyView() } }
}

public struct AnduraLink: View {
    public let label: String; public let action: () -> Void
    public init(_ label: String, action: @escaping () -> Void) { self.label = label; self.action = action }
    public var body: some View { Button(label, action: action).buttonStyle(.plain).foregroundStyle(.tint).accessibilityAddTraits(.isLink) }
}

public struct AnduraKeyboardKey: View {
    @Environment(\.anduraDesignSystem) private var system
    public let label: String
    public init(_ label: String) { self.label = label }
    public var body: some View { Text(label).font(.system(.caption, design: .monospaced)).padding(.horizontal, system.space2).padding(.vertical, system.space1).background(Color(anduraARGB: system.surfaceWarm)).clipShape(RoundedRectangle(cornerRadius: system.radiusSm)).overlay(RoundedRectangle(cornerRadius: system.radiusSm).stroke(Color(anduraARGB: system.border))).accessibilityLabel("Keyboard key \(label)") }
}

public struct AnduraChip: View {
    @Environment(\.anduraDesignSystem) private var system
    public let label: String; public var selected: Bool; public let action: () -> Void
    public init(_ label: String, selected: Bool = false, action: @escaping () -> Void = {}) { self.label = label; self.selected = selected; self.action = action }
    public var body: some View { Button(label, action: action).padding(.horizontal, system.space3).padding(.vertical, system.space1).foregroundStyle(selected ? Color(anduraARGB: system.accentOn) : Color(anduraARGB: system.foreground)).background(selected ? Color(anduraARGB: system.accent) : Color(anduraARGB: system.surface)).clipShape(Capsule()).accessibilityAddTraits(selected ? .isSelected : []) }
}

public struct AnduraAlert: View {
    @Environment(\.anduraDesignSystem) private var system
    public let message: String; public var title: String?; public var intent: AnduraIntent
    public init(_ message: String, title: String? = nil, intent: AnduraIntent = .info) { self.message = message; self.title = title; self.intent = intent }
    public var body: some View { VStack(alignment: .leading, spacing: system.space1) { if let title { Text(title).font(.headline) }; Text(message) }.frame(maxWidth: .infinity, alignment: .leading).padding(system.space4).background(intent.color(system).opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: system.radiusMd)).overlay(RoundedRectangle(cornerRadius: system.radiusMd).stroke(intent.color(system).opacity(0.5))) }
}

public struct AnduraSwitch: View {
    public let label: String; @Binding public var isOn: Bool
    public init(_ label: String, isOn: Binding<Bool>) { self.label = label; _isOn = isOn }
    public var body: some View { Toggle(label, isOn: $isOn) }
}

public struct AnduraCheckbox: View {
    public let label: String; @Binding public var checked: Bool
    public init(_ label: String, checked: Binding<Bool>) { self.label = label; _checked = checked }
    public var body: some View { Button { checked.toggle() } label: { HStack { Image(systemName: checked ? "checkmark.square.fill" : "square"); Text(label) } }.buttonStyle(.plain).accessibilityAddTraits(checked ? .isSelected : []) }
}

public struct AnduraRadio<Value: Hashable>: View {
    public let label: String; public let value: Value; @Binding public var selected: Value
    public init(_ label: String, value: Value, selected: Binding<Value>) { self.label = label; self.value = value; _selected = selected }
    public var body: some View { Button { selected = value } label: { HStack { Image(systemName: selected == value ? "largecircle.fill.circle" : "circle"); Text(label) } }.buttonStyle(.plain).accessibilityAddTraits(selected == value ? .isSelected : []) }
}

public struct AnduraTabs<Value: Hashable>: View {
    public let values: [Value]; @Binding public var selected: Value; public let label: (Value) -> String
    public init(_ values: [Value], selected: Binding<Value>, label: @escaping (Value) -> String) { self.values = values; _selected = selected; self.label = label }
    public var body: some View { Picker("Tabs", selection: $selected) { ForEach(values, id: \.self) { Text(label($0)).tag($0) } }.pickerStyle(.segmented) }
}

public struct AnduraProgress: View {
    public let value: Double?; public let label: String?
    public init(value: Double? = nil, label: String? = nil) { self.value = value; self.label = label }
    public var body: some View { if let value { ProgressView(value: value, total: 1) { if let label { Text(label) } } } else { ProgressView { if let label { Text(label) } } } }
}

public struct AnduraSkeleton: View {
    @Environment(\.anduraDesignSystem) private var system
    public var width: CGFloat?; public var height: CGFloat; public var circular: Bool
    public init(width: CGFloat? = nil, height: CGFloat = 16, circular: Bool = false) { self.width = width; self.height = height; self.circular = circular }
    public var body: some View { Group { if circular { Circle().fill(Color(anduraARGB: system.muted).opacity(0.18)) } else { RoundedRectangle(cornerRadius: system.radiusSm).fill(Color(anduraARGB: system.muted).opacity(0.18)) } }.frame(width: circular ? height : width, height: height).accessibilityLabel("Loading") }
}

public struct AnduraAccordion<Content: View>: View {
    public let title: String; @State private var expanded: Bool; private let content: Content
    public init(_ title: String, initiallyExpanded: Bool = false, @ViewBuilder content: () -> Content) { self.title = title; _expanded = State(initialValue: initiallyExpanded); self.content = content() }
    public var body: some View { DisclosureGroup(title, isExpanded: $expanded) { content } }
}

public struct AnduraStat: View {
    @Environment(\.anduraDesignSystem) private var system
    public let label: String; public let value: String; public var change: String?; public var intent: AnduraIntent
    public init(label: String, value: String, change: String? = nil, intent: AnduraIntent = .neutral) { self.label = label; self.value = value; self.change = change; self.intent = intent }
    public var body: some View { VStack(alignment: .leading, spacing: system.space1) { Text(label).font(.caption).foregroundStyle(.secondary); Text(value).font(.title); if let change { Text(change).foregroundStyle(intent.color(system)) } } }
}

public struct AnduraListItem<Leading: View, Trailing: View>: View {
    public let title: String; public var subtitle: String?; private let leading: Leading; private let trailing: Trailing
    public init(_ title: String, subtitle: String? = nil, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) { self.title = title; self.subtitle = subtitle; self.leading = leading(); self.trailing = trailing() }
    public var body: some View { HStack { leading; VStack(alignment: .leading) { Text(title); if let subtitle { Text(subtitle).font(.caption).foregroundStyle(.secondary) } }; Spacer(); trailing }.padding(.vertical, 8) }
}

public extension AnduraListItem where Leading == EmptyView, Trailing == EmptyView {
    init(_ title: String, subtitle: String? = nil) { self.init(title, subtitle: subtitle, leading: { EmptyView() }, trailing: { EmptyView() }) }
}

public struct AnduraMenuButton: View {
    public let label: String; public let items: [String]; public let onSelected: (String) -> Void
    public init(_ label: String = "More actions", items: [String], onSelected: @escaping (String) -> Void) { self.label = label; self.items = items; self.onSelected = onSelected }
    public var body: some View { Menu(label) { ForEach(items, id: \.self) { item in Button(item) { onSelected(item) } } } }
}

public struct AnduraBottomSheet<Content: View>: View {
    @Binding public var isPresented: Bool; private let content: Content
    public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) { _isPresented = isPresented; self.content = content() }
    public var body: some View { Color.clear.sheet(isPresented: $isPresented) { content.presentationDragIndicator(.visible) } }
}

public struct AnduraResponsiveContainer<Content: View>: View {
    @Environment(\.anduraDesignSystem) private var system
    private let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View { content.frame(maxWidth: system.containerMax).padding(.horizontal, system.space4) }
}

public struct AnduraResponsiveGrid<Content: View>: View {
    private let minimumWidth: Double; private let content: Content
    public init(minimumWidth: Double = 240, @ViewBuilder content: () -> Content) { self.minimumWidth = minimumWidth; self.content = content() }
    public var body: some View { LazyVGrid(columns: [GridItem(.adaptive(minimum: minimumWidth))]) { content } }
}

public struct AnduraDivider: View {
    public var label: String?
    public init(_ label: String? = nil) { self.label = label }
    public var body: some View { if let label { HStack { Divider(); Text(label).font(.caption); Divider() } } else { Divider() } }
}
