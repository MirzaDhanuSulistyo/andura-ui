package com.andura.ui

import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import org.junit.Rule
import org.junit.Test

class AnduraComponentsTest {
    @get:Rule val composeRule = createComposeRule()

    @Test fun buttonDisplaysLabel() {
        composeRule.setContent { AnduraButton("Continue", {}) }
        composeRule.onNodeWithText("Continue").assertExists()
    }
}
