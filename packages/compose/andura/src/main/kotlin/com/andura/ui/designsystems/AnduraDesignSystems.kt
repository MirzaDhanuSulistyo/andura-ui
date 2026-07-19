// GENERATED FILE - DO NOT EDIT.
package com.andura.ui.designsystems

object AnduraDesignSystems {
    val all: List<AnduraDesignSystem> = buildList {
        addAll(anduraDesignSystemsChunk01)
        addAll(anduraDesignSystemsChunk02)
        addAll(anduraDesignSystemsChunk03)
        addAll(anduraDesignSystemsChunk04)
        addAll(anduraDesignSystemsChunk05)
        addAll(anduraDesignSystemsChunk06)
        addAll(anduraDesignSystemsChunk07)
        addAll(anduraDesignSystemsChunk08)
    }
    fun byId(id: String): AnduraDesignSystem = all.firstOrNull { it.id == id } ?: defaultSystem
    val defaultSystem: AnduraDesignSystem get() = all.firstOrNull { it.id == "default" } ?: all.first()
}
