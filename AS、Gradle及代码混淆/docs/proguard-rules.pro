# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

###-----------指定代码的压缩级别------------
-optimizationpasses 5
###-----------是否使用大小写混合------------
-dontusemixedcaseclassnames
###-----------混淆时是否做预校验------------
-dontpreverify
###-----------混淆时是否记录日志------------
-verbose
###-----------忽略警告------------
-ignorewarnings
-keepattributes EnclosingMethod

###-----------把代码以及所使用到的各种第三方库代码统统移动到同一个包下------------
-repackageclasses

###-----------保证异常时显示行号------------
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

###-----------注解------------
-keepattributes *Annotation*

###-----------泛型------------
-keepattributes Signature

###-----------异常------------
-keepattributes Exceptions

-assumenosideeffects class android.util.Log {     #去掉代码里的Log
    public static boolean isLoggable(java.lang.String,int);
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

###-----------混淆时所采用的算法------------
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

###-----------保持Activity类不被混淆------------
-keep public class * extends android.app.Activity
###-----------保持AppCompatActivity类不被混淆------------
-keep public class * extends android.support.v7.app.AppCompatActivity
###-----------保持DialogFragment类不被混淆------------
-keep public class * extends android.app.DialogFragment
###-----------保持Application类不被混淆------------
-keep public class * extends android.app.Application
###-----------保持Service类不被混淆------------
-keep public class * extends android.app.Service
###-----------保持BroadcastReceiver类不被混淆------------
-keep public class * extends android.content.BroadcastReceiver
###-----------保持ContentProvider类不被混淆------------
-keep public class * extends android.content.ContentProvider
###-----------保持BackupAgentHelper类不被混淆------------
-keep public class * extends android.app.backup.BackupAgentHelper
###-----------保持Preference类不被混淆------------
-keep public class * extends android.preference.Preference
###-----------保持ILicensingService类不被混淆------------
-keep public class com.android.vending.licensing.ILicensingService

###-----------保持 native 方法不被混淆------------
-keepclasseswithmembernames class * {
    native <methods>;
}

###-----------保持自定义控件类不被混淆------------
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

###-----------保持自定义控件类不被混淆------------
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

###-----------保持自定义控件类不被混淆------------
-keepclassmembers class * extends android.app.Activity {
    public void *(android.view.View);
}

# 保留继承的
-keep public class * extends android.support.v4.**
-keep public class * extends android.support.v7.**
-keep public class * extends android.support.annotation.**

# 保留R下面的资源
-keep class **.R$* {*;}


###-----------保持枚举 enum 类不被混淆------------
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

###-----------# 保持 Parcelable 不被混淆------------
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# 保留Serializable序列化的类不被混淆
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

###-----------保持 retrofit client 不被混淆------------
-keep class com.excellence.retrofit.RetrofitHttpService { *; }

###-----------保持 retrofit 不被混淆------------
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-dontwarn javax.annotation.**

###-----------保持 okhttp 不被混淆------------
-dontwarn okio.**
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-keep class com.squareup.okhttp3.** { *;}
# A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

###-----------保持 GreenDao 不被混淆------------
-keepclassmembers class * extends org.greenrobot.greendao.AbstractDao {
public static java.lang.String TABLENAME;
public static void dropTable(org.greenrobot.greendao.database.Database, boolean);
public static void createTable(org.greenrobot.greendao.database.Database, boolean);
}
-keep class **$Properties

###-----------保持 eventbus 不被混淆------------
-keepattributes *Annotation*
-keepclassmembers class ** {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }
# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}

###-----------保持 bugly 不被混淆------------
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}

###-----------保持 gson 不被混淆------------
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }

###-----------保持 Rxjava RxAndroid 不被混淆------------
-dontwarn sun.misc.**
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
   long producerIndex;
   long consumerIndex;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}

###-----------保持 volley 不被混淆------------
-keep class com.android.volley.** { *; }
-keep class com.android.volley.toolbox.** { *; }

###-----------保持 ExoPlayer 不被混淆------------
-dontnote com.google.android.exoplayer2.ext.ima.ImaAdsLoader
-keepclassmembers class com.google.android.exoplayer2.ext.ima.ImaAdsLoader {
  <init>(android.content.Context, android.net.Uri);
}

###-----------保持 youtubetv 不被混淆------------
-keep class fr.bmartel.youtubetv.JavascriptInterface { *; }
-keepclassmembers,allowobfuscation class fr.bmartel.youtubetv.JavascriptInterface.** {
    <methods>;
}

###-----------保持 本项目以及公司依赖库和libss里面的jar 不被混淆------------
-keep class com.excellence.iptv.entity.** { *; }
-keep class com.excellence.iptv.model.entity.** { *; }
-keep class com.excellence.upgrader.entity.** { *; }
-keep class com.excellence.downloader.entity.** { *; }
-keep class com.excellence.permission.** {*; }
-keep class tv.danmaku.ijk.media.player.**{*; }
-keep class com.tosmart.systemcontrol.**{*;}
-libraryjars libs/framework_qz6.jar