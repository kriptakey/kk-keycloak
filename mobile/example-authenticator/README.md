# e2ee_device_binding_demo_flutter

A new Flutter project.

## Getting Started

- This project is a sample of mobile authenticator that can be used both for user authentication through QRCode shown on the browser and from mobile client.

- Please update `../mobile/example-client/android/app/src/main/AndroidManifest.xml` with your scheme. Ensure that data scheme must be similar to your Keycloak address.

- Please add the following parameters to Keycloak configuration file, `kkconfig.properties`:

```
kk.android.assetlinks.file=~/Documents/WorkingDir/kc-auth/test/resources/assetlinks.json
kk.ios.appsiteassoc.file=~/Documents/WorkingDir/kc-auth/test/resources/apple-app-site-association.json
```

- Both json files are used for deep link configuration that triggers authenticator application to be opened when user initiate the login process from mobile client.

- The content of `assetlinks.json`:
```
[
    {
        "relation": ["delegate_permission/common.handle_all_urls"],
        "target": {
            "namespace": "android_app",
            "package_name": "com.example.myapp", // the name of your flutter package app
            "sha256_cert_fingerprints": ["SHA256_FINGERPRINT"] // the hash of key used to sign the application (debug key or release key)
        }
    }
]
```
Replace `package_name` and `sha256_cert_fingerprints` with your configuration. To know your `package_name`, it is written on file `/home/sriyulianti/kk-github-repo/kk-keycloak/mobile/example-authenticator/android/app/build.gradle`. Refer to `namespace`. To know your `sha256_cert_fingerprints`, you can run the following command if you sign the application with debug key:

```
keytool -list -v   -alias androiddebugkey   -keystore ~/.android/debug.keystore   -storepass android   -keypass android
```
- The content of `apple-app-site-association.json` is the following:
```
{
    "applinks": {
        "apps": [],
        "details": [
            {
                "appID": "TEAMID.com.example.myapp",
                "paths": ["/action", "/action/*"]
            }
        ]
    }
}
```

- Restart your Keycloak after updating the `kkconfig.properties` file with the path to json files.

- The path to the both files must be configured in  `kkconfig.properties` and loaded to Keycloak.

- Once the application install on your phone, for instance: installed on Android, tap and hold your application. Click the little info button on the right top of the application, then click `Set as default`, enable `Open supported links`, click `Supported web addresses` and enable the link.