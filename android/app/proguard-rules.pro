########################################
## 🏗 Flutter core
########################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugins.**

########################################
## 💳 Braintree SDK (Drop-In, PayPal, Venmo, etc.)
########################################
-keep class com.braintreepayments.api.** { *; }
-dontwarn com.braintreepayments.api.**
-keepattributes Signature
-keepattributes *Annotation*

########################################
## 💰 Stripe SDK (React Native / Push Provisioning)
########################################
-keep class com.stripe.android.** { *; }
-dontwarn com.stripe.android.**
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

########################################
## 💵 Razorpay SDK
########################################
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**

########################################
## 🔒 Kotlin & AndroidX support
########################################
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keep class kotlinx.** { *; }
-dontwarn kotlinx.**
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**
-keep class androidx.fragment.app.** { *; }

########################################
## 📦 Gson / JSON / Reflection
########################################
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keepattributes *Annotation*
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

########################################
## 🔄 Retrofit / OkHttp
########################################
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-dontwarn retrofit2.**
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }

########################################
## 🧩 Keep your app package
########################################
-keep class com.mighty.eproperty.** { *; }  # ← replace with your package name
