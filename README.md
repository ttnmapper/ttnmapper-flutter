# TTN Mapper

A cross platform version of the TTN Mapper app.

## Warning

This is an alpha version of the app. It currently uses a development version of
the flutter plugin of mapboxgl.

## Configuration

In order for the app to work properly a mapbox token needs to be configured.

### iOS

Add these lines to your Info.plist:
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location.</string>
<key>MGLMapboxAccessToken</key>
<string>YOUR_TOKEN_HERE</string>
<key>io.flutter.embedded_views_preview</key>
```

### Android
Add Mapbox read token value in the application manifest *android/app/src/main/AndroidManifest.xml*:

```
  <application
    ...
    <meta-data android:name="com.mapbox.token" android:value="YOUR_TOKEN_HERE" />
    ...
  </application>
```

## Contributing

If you wish to contribute be sure to check the [contribution guide](CONTRIBUTING.md).

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
