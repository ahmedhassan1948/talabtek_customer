android {
    namespace = "com.talabtk.order"
    compileSdk = 36 // تحديث مستوى التجميع إلى 36

    defaultConfig {
        applicationId = "com.talabtk.order"
        minSdk = flutter.minSdkVersion
        targetSdk = 36 // تحديث التارقت إلى 36 مباشرة
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
