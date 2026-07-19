import SwiftUI

public struct AnduraButton: View {
    public let label: String
    public let action: () -> Void
    public var isEnabled: Bool = true
    public init(label: String, isEnabled: Bool = true, action: @escaping () -> Void) { self.label = label; self.isEnabled = isEnabled; self.action = action }
    public var body: some View { Button(label, action: action).disabled(!isEnabled).frame(maxWidth: .infinity, minHeight: 56).buttonStyle(.borderedProminent) }
}

public struct AnduraIconButton<Content: View>: View {
    private let action: () -> Void; private let content: Content; private let label: String
    public init(label: String, action: @escaping () -> Void, @ViewBuilder content: () -> Content) { self.label = label; self.action = action; self.content = content() }
    public var body: some View { Button(action: action) { content }.accessibilityLabel(label) }
}

public struct AnduraCard<Content: View>: View {
    private let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View { content.padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 16)) }
}

public struct AnduraBadge: View { public let label: String; public init(label: String) { self.label = label }; public var body: some View { Text(label).font(.caption).padding(.horizontal, 12).padding(.vertical, 4).background(.tint.opacity(0.15)).clipShape(Capsule()) } }

public struct AnduraTextField: View { @Binding public var value: String; public let label: String; public var isError = false; public init(_ value: Binding<String>, label: String, isError: Bool = false) { _value = value; self.label = label; self.isError = isError }; public var body: some View { TextField(label, text: $value).textFieldStyle(.roundedBorder).overlay(isError ? RoundedRectangle(cornerRadius: 6).stroke(.red) : nil) } }

public struct AnduraDialog<DialogContent: View>: View { @Binding public var isPresented: Bool; public let title: String; private let dialogContent: DialogContent; public init(isPresented: Binding<Bool>, title: String, @ViewBuilder content: () -> DialogContent) { _isPresented = isPresented; self.title = title; self.dialogContent = content() }; public var body: some View { if isPresented { VStack(alignment: .leading, spacing: 16) { HStack { Text(title).font(.headline); Spacer(); Button("Close") { isPresented = false } }; dialogContent }.padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 24)) } } }

public struct AnduraSearchField: View { @Binding public var value: String; public init(_ value: Binding<String>) { _value = value }; public var body: some View { TextField("Search", text: $value).textFieldStyle(.roundedBorder) } }

public struct AnduraEmptyState: View { public let message: String; public init(_ message: String) { self.message = message }; public var body: some View { Text(message).foregroundStyle(.secondary).frame(maxWidth: .infinity, minHeight: 80) } }

public struct AnduraLoadingOverlay<Content: View>: View { public let loading: Bool; private let content: Content; public init(loading: Bool, @ViewBuilder content: () -> Content) { self.loading = loading; self.content = content() }; public var body: some View { ZStack { content; if loading { ProgressView() } } } }

public struct AnduraErrorText: View { public let message: String; public init(_ message: String) { self.message = message }; public var body: some View { Text(message).foregroundStyle(.red).accessibilityAddTraits(.isStaticText) } }

public struct AnduraUserAvatar: View { public let name: String; public init(_ name: String) { self.name = name }; public var body: some View { Text(name.prefix(1).uppercased()).frame(width: 40, height: 40).background(.tint.opacity(0.2)).clipShape(Circle()) } }

public struct AnduraNotificationButton: View { public let hasNotification: Bool; public let action: () -> Void; public init(hasNotification: Bool = false, action: @escaping () -> Void) { self.hasNotification = hasNotification; self.action = action }; public var body: some View { Button(action: action) { Image(systemName: hasNotification ? "bell.badge" : "bell") }.accessibilityLabel("Notifications") } }

public struct AnduraTextArea: View { @Binding public var value: String; public init(_ value: Binding<String>) { _value = value }; public var body: some View { TextEditor(text: $value).frame(minHeight: 100).overlay(RoundedRectangle(cornerRadius: 10).stroke(.secondary)) } }
public struct AnduraSelect: View { @Binding public var value: String; public let options: [String]; public init(_ value: Binding<String>, options: [String]) { _value = value; self.options = options }; public var body: some View { Picker("Select", selection: $value) { ForEach(options, id: \.self) { Text($0) } } } }
public struct AnduraPasswordField: View { @Binding public var value: String; public init(_ value: Binding<String>) { _value = value }; public var body: some View { SecureField("Password", text: $value).textFieldStyle(.roundedBorder) } }
public struct AnduraChoiceRow: View { public let values: [String]; @Binding public var selected: String; public init(values: [String], selected: Binding<String>) { self.values = values; _selected = selected }; public var body: some View { Picker("Choice", selection: $selected) { ForEach(values, id: \.self) { Text($0).tag($0) } }.pickerStyle(.segmented) } }
public struct AnduraCheckOption: View { public let label: String; @Binding public var checked: Bool; public init(_ label: String, checked: Binding<Bool>) { self.label = label; _checked = checked }; public var body: some View { Toggle(label, isOn: $checked) } }
public struct AnduraSettingsTile: View { public let title: String; public let action: () -> Void; public init(_ title: String, action: @escaping () -> Void) { self.title = title; self.action = action }; public var body: some View { Button(title, action: action).frame(maxWidth: .infinity, alignment: .leading) } }
public struct AnduraPage<Content: View>: View { private let content: Content; public init(@ViewBuilder content: () -> Content) { self.content = content() }; public var body: some View { NavigationStack { ScrollView { content.padding() } } } }
