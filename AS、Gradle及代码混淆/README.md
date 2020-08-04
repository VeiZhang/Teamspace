# AS、Gradle及代码混淆

* [Android Studio](#1)
    * [工程](#1.1)
    * [使用说明与技巧](#1.2)
    * [插件集合](#1.3)


* [Gradle](#2)
    * [gradle讲解](#2.1)
    * [依赖配置](#2.2)
    * [编译异常集合](#2.3)


* [代码混淆](#3)
    * [反编译](#3.1)
    * [混淆规则](#3.2)
    * [常用的混淆集合](#3.3)
    * [加壳](#3.4)

<br>

## <span id="1">Android Studio</span>

<br>

### <span id="1.1">工程</span>

  * 根据文档[AndroidStudio兼容导入Eclipse工程][AndroidStudio兼容导入Eclipse工程]说明，把Eclipse转为AndroidStudio工程

<br>

  * framework.jar导入
    * 根目录build.gradle配置。**注：新版的Android Studio不用添加该配置，也可以使用**
      ```
      allprojects {
        repositories {
            jcenter()
        }

        // 增加指定的framework.jar
        gradle.projectsEvaluated {
          tasks.withType(JavaCompile) {
            // 使用相对路径，就不需要每次checkout代码的时候修改路径了
            // -Xbootclasspath/p: 表示根目录
            // Module\\libs\\framework.jar jar位置
            options.compilerArgs.add('-Xbootclasspath/p:Module\\libs\\framework.jar')
          }
        }
      }
      ```
    * 项目Module目录build.gradle配置
      ```
      dependencies {
        provided files(‘libs/framework.jar’)
      }
      ```

<br>

  * layoutlib.jar导入
    在module的gradle配置文件中，写一个函数，动态获取layoutlib.jar路径，然后加到dependencies中即可：**注意下面脚本顺序不能改变，否则有可能导致读取路径不对**
    ```
    android{
      compileSdkVersion 17
      buildToolsVersion "22.0.1"
    }

    dependencies {
      provided files(getLayoutLibPath())
    }

    def getLayoutLibPath() {
      // 进入到sdk路径，找到对应compileSdkVersion版本的layoutlib.jar
      return "${android.getSdkDirectory().getAbsolutePath()}" + "\\platforms\\" + android.compileSdkVersion + "\\data\\layoutlib.jar"
    }
    ```

<br>

### <span id="1.2">使用说明与技巧</span>

<br>

  * 宣传一下我的[IDE配置][IDE配置] (包含Kotlin)，如果你们有谁喜欢，可以拿去使用或者修改：**在导入之前，可以先保存自己的配置文件，不喜欢还可以恢复回去**
  ![AndroidStudio风格][AndroidStudio风格]

  * 设置缩进规则：写代码时按tab键，生成的是四个空格，而非一个tab
  ![AndroidStudio缩进规范][AndroidStudio缩进规范]

  * 设置成员变量模板
  ![AndroidStudio成员模板][AndroidStudio成员模板]

  * 代码模板：在输入指定代码时会输入已写好的模板
  ![AndroidStudio代码模板][AndroidStudio代码模板]

  * 文件模板：在生成文件时，文件内自带已写好的模板
  ![AndroidStudio文件模板][AndroidStudio文件模板]

  * svn使用如同TortoiseSVN、git、GitHub使用如同TortoiseGit

  * lint检查

  * 生成APK

  * 一些路径说明
    * 启动配置
    ```
    路径：Android Studio\bin\studio64.exe.vmoptions 64位系统配置
    Android Studio\bin\studio.exe.vmoptions 32位系统配置
    加快AndroidStudio启动速度，修改配置，然后重启
    // 最小的启动内存
    -Xms512m
    // 最大的启动内存，一般来说，在允许范围内该值越大，启动越快
    -Xmx1536m
    ```

    * AndroidStudio插件
    ```
    路径：C:\Users\VeiZhang\.AndroidStudio3.1\config\plugins
    ```

    * AndroidStudio依赖缓存
    ```
    路径：C:\Users\VeiZhang\.gradle\caches\modules-2\files-2.1
    ```

    * gradle工具
    ```
    路径：C:\Users\VeiZhang\.gradle\wrapper\dists
    ```

    * [源码关联][jdk.table.xml]
    ```
    C:\Users\VeiZhang\.AndroidStudio\config\options\jdk.table.xml
    // 查找缺失的源码路径，根据当前的版本填写对应的路径
    <jdk>
    ·
    ·
    ·
        <sourcePath>
          <root type="composite">
            // 此处如果没有，则为缺失源码路径，需要填写
            <root url="file://C:/Android/Sdk/sources/android-23" type="simple" />
          </root>
        </sourcePath>
      </roots>
      <additional jdk="1.8" sdk="android-23" />
    </jdk>
    ```

  * 其他一些说明总结：[AndroidStudio使用小技巧和快捷键][AndroidStudio使用小技巧和快捷键]

  * 调试工具

	* APK解析
	直接把apk用AndroidStudio打开
    ![apk解析][apk解析]
	* 布局解析
	tools->layout inspector
	![layout inspector][layout_inspector]
	* 内存/CPU等解析Profiler
	![Profiler][profiler]

<br>

### <span id="1.3">插件集合</span>

  * 插件安装的两种方式：在线安装、本地安装

  * [插件集合][插件集合]

<br>
<br>

## <span id="2">Gradle</span>


### <span id="2.1">gradle讲解</span>

* root目录

  ```
  // Top-level build file where you can add configuration options common to all sub-projects/modules.

  // buildscript中的声明是gradle脚本自身需要使用的资源。
  // 可以声明的资源包括第三方插件、maven仓库地址等。
  buildscript {
      repositories {
          jcenter()
      }
      dependencies {
          classpath 'com.android.tools.build:gradle:2.3.3'
          // 第三方插件
          classpath 'org.greenrobot:greendao-gradle-plugin:3.2.0'
          // NOTE: Do not place your application dependencies here; they belong
          // in the individual module build.gradle files
      }
  }

  // 定义的属性会被应用到所有 module
  allprojects {
      repositories {
          jcenter()
          // 引入仓库地址
          maven { url "http://192.168.2.211:8081/artifactory/gradle-release-local/" }
      }
  }

  task clean(type: Delete) {
      delete rootProject.buildDir
  }
  ```

* Module目录

  ```
  // 说明module的类型，com.android.application为程序，com.android.library为库
  apply plugin: 'com.android.application'
  android {
    // 编译的SDK版本
    compileSdkVersion 22
    // 编译的Tools版本
    buildToolsVersion "22.0.1"
    // 程序的默认配置，注意，如果在AndroidMainfest.xml里面定义了与这里相同的属性，会以这里的为主
    defaultConfig {
      // 应用程序的包名
      applicationId "com.nd.famlink"
      // 支持的最低版本
      minSdkVersion 8
      // 支持的目标版本
      targetSdkVersion 19
      // 根据svn版本号生成APK版本号
      versionCode getSvnVersionCode()
      // 根据svn版本号生成APK版本名
      versionName generateVersionName()
    }

    // 目录指向配置
    sourceSets {
        main {
          // 指定AndroidManifest文件
          manifest.srcFile 'AndroidManifest.xml'
          // 指定source目录
          java.srcDirs = ['src']
          // 指定source目录
          resources.srcDirs = ['src']
          // 指定source目录
          aidl.srcDirs = ['src']
          // 指定source目录
          renderscript.srcDirs = ['src']
          // 指定资源目录
          res.srcDirs = ['res']
          // 指定assets目录
          assets.srcDirs = ['assets']
          // 指定lib库目录
          jniLibs.srcDirs = ['libs']
      }
    }

    // 签名配置
    signingConfigs {
      //发布版签名配置
      release {
        // 密钥文件路径
        storeFile file("fk.keystore")
        // 密钥文件密码
        storePassword "123"
        // key别名
        keyAlias "fk"
        // key密码
        keyPassword "123"
      }

      // debug版签名配置
      debug {
        storeFile file("fk.keystore")
        storePassword "123"
        keyAlias "fk"
        keyPassword "123"
      }
    }

    // 编译类型
    buildTypes {
      // 发布，正式的apk
      release {
        // 开启ZipAlign优化
        zipAlignEnabled true
        // 移除无用的resource文件，注意，可能会引起血案，谨慎使用
        shrinkResources true
        // 混淆开启
        minifyEnabled true
        // 指定混淆规则文件
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-project.txt'
        // 设置签名信息
        signingConfig signingConfigs.release
      }

      // 调试
      debug {
        // 与release相同的签名
        signingConfig signingConfigs.release
      }
    }

    lintOptions {
      // lint时候终止错误上报,防止编译失败
      checkReleaseBuilds false
      abortOnError false
    }

    // 生成apk时，重命名：可根据多渠道的参数修改
    applicationVariants.all { variant ->
      variant.outputs.all { output ->
          if (!variant.buildType.isDebuggable()) {
              outputFileName = "BlackWhiteList_" + getVersionName() + ".apk"
          }
      }
    }
  }

  // AndroidStudio3.0后compile依赖关系已被弃用，被implementation和api替代，加快了编译速度，优化生成apk大小
  dependencies {
    // 编译lib目录下的.jar文件
    compile fileTree(include: ['*.jar'], dir: 'libs')
    // 编译依赖工程
    compile project(':retrofit')
    // 编译来自Jcenter的第三方开源库，来源库可自行添加
    compile 'com.excellence:basetools:1.2.5'
    // 测试项目需要引用的
    testCompile 'xxxx'
  }

  // 自定义变量
  def name="1.4.2"
  // 自定义函数
  def generateVersionName() {
      println "----打印----" + name
      name + getDate() + "_" + getSvnVersionCode()
  }

  // 读取svn版本号
  def getSvnVersionCode() {
      def proc = ("svnversion -c " + getBuildDir().parent).execute();
      proc.waitFor();
      def version = proc.in.text;
      Pattern pattern = Pattern.compile("(\\d+\\:)?(\\d+)\\D");
      Matcher matcher = pattern.matcher(version);
      if (matcher.find()) {
          version = matcher.group(matcher.groupCount());
      }
      try {
          return Integer.parseInt(version);
      } catch (e) {
          println e.getMessage();
      }
      return 0;
  }

  // 读取当前时间
  def getDate() {
      String date = new SimpleDateFormat("MMddyyyy").format(new Date());
      return date;
  }

  // 自定义任务，控制台上在当前build.gradle所在的目录里执行gradle makeJar（任务名字），即执行生成jar的任务
  task makeJar(type: Copy) {
    delete 'build/libs/mysdk.jar'
    from('build/intermediates/bundles/release/')
    into('build/libs/')
    include('classes.jar')
    rename ('classes.jar', 'mysdk.jar')
  }
  ```

* 多渠道

  ```
  // 产品配置
  productFlavors {
      content {
        // 不同的包名
        applicationId "com.excellence.appstore"
        // 不同的版本名
        versionName generateVersionName() + "-C"
        // 动态生成的常量，生成的常量在BuildConfig类中
        buildConfigField('String', 'MAIN_SERVER', '"http://www.g-appmarket.com:8080/appmarket/"')
        // 动态生成的资源引用R.string.name->hello
        resValue("string" , "name", "hello")
        // 动态资源名，被引用到AndroidManifest文件里占位资源
        manifestPlaceholders = [app_name: "@string/content_app_name"]
      }

      pure {
        applicationId "com.excellence.appmarket"
        versionName generateVersionName() + "-P"
        buildConfigField('String', 'MAIN_SERVER', '"http://www.wrup9.com:8080/appmarket/"')
        manifestPlaceholders = [app_name: "@string/pure_app_name"]
      }

      indonesia_apps {
        applicationId "com.excellence.appmarket"
        versionName generateVersionName()
        buildConfigField('String', 'MAIN_SERVER', '"http://apps.dens.tv:8701/appmarket/"')
        manifestPlaceholders = [app_name: "@string/app_name"]
      }
  }

  // 编译类型
  buildTypes {
      debug {
          buildConfigField('boolean', 'LOG_DEBUG', 'true')
      }

      release {
          buildConfigField('boolean', 'LOG_DEBUG', 'false')
      }

      security {
          buildConfigField('boolean', 'LOG_DEBUG', 'false')
      }
  }

  // 多渠道资源，根据不同的产品配置，两种方式：
  // ①指定目录
  // ②如下图，直接创建多渠道目录，自动会读取对应的代码和资源
  sourceSets {
      content {
        // 指定content编译时的资源目录是res-content，默认资源目录是res
        res.srcDirs = ['src/main/res-content']
      }
      pure {
        res.srcDirs = ['src/main/res-pure']
      }
      indonesia_apps {
        // 指定content编译时的AndroidManifest文件是AndroidManifest_launch
        manifest.srcFile 'src/main/AndroidManifest_launch.xml'
        res.srcDirs = ['src/main/res-indonesia']
      }
  }
  ```

  ![多渠道资源][多渠道资源]


### <span id="2.2">[依赖配置][依赖配置]</span>

  > 方便管理gradle脚本。

  任意路径指向，对于多module管理
  ![gradle脚本1][gradle脚本1]
  ![gradle脚本2][gradle脚本2]

### <span id="2.3">[编译异常集合][编译异常集合]</span>

  > 记录gradle编译不通过的异常以及解决办法。


  <br>
  <br>


## <span id="3">代码混淆</span>


### <span id="3.1">反编译</span>

 * 反编译工具

	* [jadx][jadx]
	  **推荐，简单粗暴，反编译比较完整，同时尽量保留可识别代码；支持导出gradle源码**

    * ~~apktool~~
      资源文件获取，可以提取出图片文件和布局文件进行使用查看：`apktool.bat d -f [apk文件] [输出文件夹]`
      更简单的方法是，把后缀.apk换成.zip，直接打开，就可以看到资源目录

    * ~~dex2jar~~
      将apk反编译成Java源码（classes.dex转化成jar文件）：`dex2jar.bat [apk文件]`

    * ~~jd-gui~~
      查看APK中classes.dex转化成出的jar文件，即源码文件：用jd-gui.exe打开上面生成的classes.dex即可

    ~~注：**AndroidKiller**是一个反编译工具，一步到位，看Java源码的时候，需要借助smail转java的工具。另外将test.apk的apk文件更换后缀名为test.zip，可以提取出资源图片文件等等。~~

<br>

  * 未混淆
    未混淆的app，反编译可以看到源码：
    ![未混淆][未混淆]

  * 混淆
    混淆app之后，反编译得到的源码：
    ![混淆][混淆]


### <span id="3.2">混淆规则</span>

  * 关键字

    | 关键字 | 描述 |
    | --- | ---- |
    | keep | 保留类和类中的成员，防止它们被移除或被重命名 |
    | keepnames | 保留类和类中的成员，防止它们被重命名，但当成员没有被引用时会被移除 |
    | keepclassmembers | 只保留类中的成员，防止它们被移除或者被重命名 |
    | keepclassmembernames | 只保留类中的成员，防止它们被重命名，但当成员没有被引用时会被移除 |
    | keepclasseswithmembers | 防止**拥有该成员的**类和成员被移除或被重命名，前提是指明的类中的成员必须存在，如果不存在则还是会混淆 |
    | keepclasseswithmembernames | 防止**拥有该成员的**类和成员被重命名，但当成员没有被引用时会被移除，前提是指明的类中的成员必须存在，如果不存在则还是会混淆 |

  * 通配符

    | 通配符 | 描述 |
    | --- | ---- |
    | `<field>` | 匹配类中的所有字段 |
    | `<method>` | 匹配类中的所有方法 |
    | `<init>` | 匹配类中的所有构造函数 |
    | `*` | `匹配任意长度字符，但不含包名分隔符（.）；如完整包名：com.example.test.util，使用com.*、com.example.*都是无法匹配的，因为*无法匹配包名中的分隔符，正确的匹配方式是com.example.*.*、com.example.test.*；如果你不写任何其他内容，只有一个*，则表示匹配所有的字符` |
    | `**` | 匹配任意长度字符，并且包含包名分隔符（.）；如混淆文件里的：dontwarn android.support.**就可以匹配android.support包下的所有内容，包括任意长度的子包 |
    | `***` | 匹配任意参数类型；如`void set(***)`匹配任意传入的参数类型，`*** get()`就能匹配任意返回值的类型 |
    | `...` | 匹配任意长度的任意类型参数；如void test(...)匹配`void test(String a)`或`void test(int a, String b)`等等 |

  * 常见规则

    形如：
    ```
    [关键字][类]{
        [成员]
    }
    ```

    包：`com.example.test`
    类：A

    * 不混淆某个类
    ```
    -keep public class com.example.test.A { *; }
    ```

    * 不混淆某个包下所有的类
    ```
    -keep class com.example.test.**{ *; }
    ```

    * 不混淆某个类的子类
    ```
    -keep public class * extends com.example.test.A { *; }
    ```

    * 不混淆所有类名中包含了"关键字"的类及成员
    ```
    -keep public class **.*model*.** { *; }
    ```

    * 不混淆某个接口
    ```
    -keep class * implements com.example.test.Interface { *; }
    ```

    * 不混淆某个类的构造方法
    ```
    -keepclassmembers class com.example.test.A {
        public <init>();
    }
    ```

    * 不混淆某个类的特定的方法
    ```
    -keepclassmembers class com.example.test.A {
        public void test(java.lang.String);
    }
    ```

    * 不混淆某个类的内部类
    ```
    -keep class com.example.test.A$* {
        *;
    }
    ```

### <span id="3.3">常用的混淆集合</span>

* App开启混淆配置
  ```
  release {
      // 开启混淆
      minifyEnabled true

      // 配置混淆规则
      proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
  }
  ```

* Library开启混淆配置
  ```
  buildTypes {
	    release {
	        consumerProguardFiles 'proguard-rules.pro'
	    }
	    security {
	        consumerProguardFiles 'proguard-rules.pro'
	    }
	}
  ```


* 说明
  开启App的混淆，在一定程度上保护自己辛苦开发的成果，即反编译出来的源码是`a b c...`这样的，但是仍然可以被反编译看到AndroidManifest和资源文件。配置混淆文件是为了防止某些功能的正常使用，代码过于混淆，会导致功能无法使用，这个时候就要保持不被混淆。

* 混淆后的代码追踪
  代码开启混淆之后，调试app或者遇到app异常时，打印里面显示的则是`a b c...`这种的异常，定位不到异常的位置，这个时候在目录`build\outputs\mapping\release`里，使用mapping.txt，结合SDK里的工具`sdk\tools\proguard\bin\proguardgui.bat`->ReTrace，进行定位异常，基本上可以定位，然后解决异常错误。

[proguard-rules.pro][proguard-rules.pro]


### <span id="3.4">~~加壳~~</span>

* **目前仅了解，加壳的方式存在一些坑，未解决：1.莫名其妙编译的so缺失；2.某版本之后，进入应用非常慢**

加壳是在二进制的程序中植入一段代码，在运行的时候优先取得程序的控制权，做一些额外的工作。是应用加固的一种手法对原始二进制原文进行加密/隐藏/混淆。加壳的程序可以有效阻止对程序的反汇编分析，常用来保护软件版权，防止被软件破解。

  * Android Dex文件加壳原理
    Android Dex文件大量使用引用给加壳带来了一定的难度，但是从理论上讲，Android APK加壳也是可行的。

  * 加壳程序：加密源程序为解壳数据、组装解壳程序和解壳数据

  * 解壳程序：解密解壳数据，并运行时通过DexClassLoader动态加载

  * 源程序：需要加壳处理的被保护代码

<br>

  * 优势
    * 保护自己核心代码算法,提高破解/盗版/二次打包的难度
    * 还可以缓解代码注入/动态调试/内存注入攻击

  * 劣势
    * 影响兼容性
    * 影响程序运行效率
    * 常用的加壳方式
      [腾讯乐固][腾讯乐固]


[AndroidStudio兼容导入Eclipse工程]:./docs/AndroidStudio兼容导入Eclipse工程.pdf
[IDE配置]:./docs/settings_v1.2.9.jar
[AndroidStudio风格]:./images/AndroidStudio风格.png
[AndroidStudio缩进规范]:./images/AndroidStudio缩进规范.png
[AndroidStudio成员模板]:./images/AndroidStudio成员模板.png
[AndroidStudio代码模板]:./images/AndroidStudio代码模板.png
[AndroidStudio文件模板]:./images/AndroidStudio文件模板.png
[jdk.table.xml]:./docs/jdk.table.xml
[AndroidStudio使用小技巧和快捷键]:http://note.youdao.com/noteshare?id=e7bdef1ff8f3763fcab662fbf0d3663e&sub=12548210216F41ACB91622620084B446
[apk解析]:./images/apk解析.png
[layout_inspector]:./images/layout_inspector.png
[profiler]:./images/profiler.png
[插件集合]:./docs/插件集合.md
[proguard-rules.pro]:./docs/proguard-rules.pro
[依赖配置]:./docs/依赖配置.md
[多渠道资源]:./images/多渠道资源.png
[gradle脚本1]:./images/gradle脚本1.png
[gradle脚本2]:./images/gradle脚本2.png
[编译异常集合]:http://note.youdao.com/noteshare?id=c4b4f0dbf46277a30195207759513442&sub=8B57BCA2F7D64335886FB58EB7650CA0
[未混淆]:https://github.com/VeiZhang/cdn.io/blob/master/images/%E6%9C%AA%E6%B7%B7%E6%B7%86.png?raw=true
[混淆]:https://github.com/VeiZhang/cdn.io/blob/master/images/%E6%B7%B7%E6%B7%86.png?raw=true
[腾讯乐固]:https://cloud.tencent.com/product/ms
[jadx]:https://github.com/skylot/jadx
