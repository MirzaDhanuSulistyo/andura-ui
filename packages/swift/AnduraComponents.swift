import SwiftUI

public struct AnduraButton: View {
    public let label: String
    public let action: () -> Void
    public var isEnabled: Bool = true

    public init(label: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.label = label; self.isEnabled = isEnabled; self.action = action
    }

    public var body: some View {
        Button(label, action: action)
            .disabled(!isEnabled)
            .frame(maxWidth: .infinity, minHeight: 56)
            .buttonStyle(.borderedProminent)
    }
}

public struct AnduraCard<Content: View>: View {
    private let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View { content.padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 16)) }
}

public struct AnduraBadge: View {
    public let label: String
    public init(label: String) { self.label = label }
    public var body: some View { Text(label).font(.caption).padding(.horizontal, 12).padding(.vertical, 4).background(.tint.opacity(0.15)).clipShape(Capsule()) }
}

public struct AnduraDialog<DialogContent: View>: View {
    @Binding public var isPresented: Bool
    public let title: String
    private let dialogContent: DialogContent
    public init(isPresented: Binding<Bool>, title: String, @ViewBuilder content: () -> DialogContent) { _isPresented = isPresented; self.title = title; self.dialogContent = content() }
    public var body: some View {
        if isPresented {
            VStack(alignment: .leading, spacing: 16) {
                HStack { Text(title).font(.headline); Spacer(); Button("Close") { isPresented = false } }
                dialogContent
            }.padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}
