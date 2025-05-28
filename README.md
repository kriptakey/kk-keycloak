# kk-keycloak

## Keycloak

We provide a plugin that can be integrated to the existing Keycloak. The plugin is available on `keycloak/provider`. You can refer to the documentation how to use the plugin.

## Mobile

We provide authenticator sample that we develop by using Flutter in mobile. The sample is also integrated with E2EE mobile SDK that can be called for cryptographic operations in the sample. 

We assume that you are familiar with Flutter and have installed and configured Flutter before running the sample application. You can update the SDK location before running the application by editing `mobile/example/pubspec.yaml`:

```
kms_e2ee_package:
    path: ../sdk/kms_e2ee_package
```

Please update the Keycloak IP address and realm with your configuration when trying to run the application. You can change the IP address on `mobile/example/lib/core/api_client.dart` file

Please read `README.md` file on each mobile application sample to know how to get started with the sample. 