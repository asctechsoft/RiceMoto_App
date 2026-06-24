plugins {
    id("com.android.application")
    id("kotlin-android")
    // Firebase: applies google-services.json (must be after Android/Kotlin plugins).
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.company.ricemoto"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Must match the package_name in android/app/google-services.json.
        applicationId = "com.company.ricemoto"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "env"

    productFlavors {
        create("alpha") {
            dimension = "env"
            versionNameSuffix = "-alpha"
        }
        create("dev") {
            dimension = "env"
            versionNameSuffix = "-dev"
        }
        create("product") {
            dimension = "env"
        }
    }

    buildTypes {
        release {
            // TODO: Replace with real signing config before publishing.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
