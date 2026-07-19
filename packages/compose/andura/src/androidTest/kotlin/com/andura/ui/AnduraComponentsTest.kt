package com.andura.ui

import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import com.andura.ui.designsystems.AnduraDesignSystems
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test

class AnduraComponentsTest {
    @get:Rule val composeRule = createComposeRule()

    @Test fun catalogContainsEveryDesignSystem() {
        assertEquals(151, AnduraDesignSystems.all.size)
        assertEquals("Linear", AnduraDesignSystems.byId("linear-app").name)
    }

    @Test fun buttonDisplaysLabel() {
        composeRule.setContent { AnduraButton("Continue", {}) }
        composeRule.onNodeWithText("Continue").assertExists()
    }
}
