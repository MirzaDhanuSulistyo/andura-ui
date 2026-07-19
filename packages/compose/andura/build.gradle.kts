plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
    id("maven-publish")
}

android {
    namespace = "com.andura.ui"
    compileSdk = 35
    defaultConfig { minSdk = 21 }
    publishing { singleVariant("release") }
}

kotlin { jvmToolchain(17) }

android { buildFeatures { compose = true } }

group = "com.andura.ui"
version = "0.2.0"

afterEvaluate {
    publishing {
        publications {
            create<MavenPublication>("release") { from(components["release"]) }
        }
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2025.01.00"))
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    androidTestImplementation("androidx.compose.ui:ui-test-junit4")
    androidTestImplementation("junit:junit:4.13.2")
}
