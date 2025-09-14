# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Flutter engine
-keep class io.flutter.embedding.** { *; }

# Keep audio players
-keep class xyz.luan.audioplayers.** { *; }

# Keep webview
-keep class io.flutter.plugins.webviewflutter.** { *; }

# Keep shared preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep secure storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep crypto
-keep class dart.core.** { *; }

# Keep package info
-keep class dev.fluttercommunity.plus.package_info.** { *; }

# Keep provider
-keep class provider.** { *; }

# Keep HTTP
-keep class io.flutter.plugins.connectivity.** { *; }

# General Android rules
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum values
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep R classes
-keep class **.R$* {
    public static <fields>;
}

# Keep WebView
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep audio files
-keep class **.R$raw { *; }

# Keep assets
-keep class **.R$drawable { *; }
-keep class **.R$mipmap { *; }

# Keep Google Play Core classes
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
