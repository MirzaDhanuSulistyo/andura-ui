import SwiftUI

#Preview("Andura core") {
    VStack(spacing: 16) {
        AnduraBadge(label: "Active")
        AnduraButton(label: "Continue", action: {})
        AnduraCard { Text("Shared surface") }
    }
    .padding()
}
