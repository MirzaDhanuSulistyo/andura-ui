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
version = "0.3.0"

afterEvaluate {
    publishing {
        publications {
            create<MavenPublication>("release") {
                from(components["release"])
                artifactId = "andura"
                pom {
                    name.set("Andura UI Compose")
                    description.set("Jetpack Compose adapter for the Andura UI design system.")
                    url.set("https://github.com/MirzaDhanuSulistyo/andura-ui")
                    licenses {
                        license {
                            name.set("MIT License")
                            url.set("https://opensource.org/licenses/MIT")
                        }
                    }
                    scm { url.set("https://github.com/MirzaDhanuSulistyo/andura-ui") }
                }
            }
        }
        repositories {
            maven {
                name = "GitHubPackages"
                url = uri("https://maven.pkg.github.com/MirzaDhanuSulistyo/andura-ui")
                credentials {
                    username = System.getenv("GITHUB_ACTOR")
                    password = System.getenv("GITHUB_TOKEN")
                }
            }
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
