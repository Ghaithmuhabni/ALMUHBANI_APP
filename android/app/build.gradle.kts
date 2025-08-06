plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Fixed: Kotlin DSL syntax
    id("dev.flutter.flutter-gradle-plugin") // Must be after Android & Kotlin plugins
}

android {
    namespace = "com.example.flutter_application_1"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.android.application"
        minSdk = flutter.minSdkVersion.toInt()
        targetSdk = flutter.targetSdkVersion.toInt()
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.9.0") // Example dependency (adjust as needed)
}