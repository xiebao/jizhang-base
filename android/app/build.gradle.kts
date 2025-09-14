plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.jizhang.goodgood"
    compileSdk = 35  // 升级到Android 15 (API 35)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            // 生产环境签名配置
            keyAlias = "mathfish"
            keyPassword = "mathfish123"
            storeFile = file("../keystore/mathfish.jks")
            storePassword = "mathfish123"
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.jizhang.goodgood"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 35  // 升级到Android 15 (API 35)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // 生产环境配置
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false  // 禁用代码混淆以避免Play Core兼容性问题
            isShrinkResources = false  // 禁用资源压缩
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // 启用AAB打包
    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 完全移除Play Core库以避免兼容性问题
    // 如果将来需要应用内更新等功能，可以使用新的Play库：
    // implementation("com.google.android.play:app-update:2.1.0")
    // implementation("com.google.android.play:review:2.0.1")
    
    // 添加Android 15兼容性配置
    implementation("androidx.core:core:1.13.1")
}
