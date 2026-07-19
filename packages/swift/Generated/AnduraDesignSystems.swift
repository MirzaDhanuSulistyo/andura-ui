// GENERATED FILE - DO NOT EDIT.
import Foundation

public enum AnduraDesignSystems {
    public static let all: [AnduraDesignSystem] = [
        anduraDesignSystemsChunk01,
        anduraDesignSystemsChunk02,
        anduraDesignSystemsChunk03,
        anduraDesignSystemsChunk04,
        anduraDesignSystemsChunk05,
        anduraDesignSystemsChunk06,
        anduraDesignSystemsChunk07,
        anduraDesignSystemsChunk08,
    ].flatMap { $0 }
    public static func byID(_ id: String) -> AnduraDesignSystem { all.first { $0.id == id } ?? defaultSystem }
    public static var defaultSystem: AnduraDesignSystem { all.first { $0.id == "default" } ?? all[0] }
}
