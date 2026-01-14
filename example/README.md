# Hybrid Map Marker - Example

This example demonstrates how to use the `hybrid_map_marker` package to create custom Google Maps markers from Flutter widgets.

## Features Demonstrated

This example shows:

- ✨ Creating custom markers from Flutter widgets
- 🎨 Using icon-based markers with custom styling
- 🚀 Using SVG images in markers with proper caching
- 📍 Displaying multiple custom markers on a Google Map

## What This Example Does

The app displays a Google Map with two custom markers:

1. **Location Marker** - A circular amber container with a location icon
2. **SVG Marker** - A circular amber container with an SVG user icon

Both markers are created using the `HybridMapMarker` package, demonstrating different use cases.

## Setup

### 1. Add Your Google Maps API Key

Before running the example, you need to add your Google Maps API key:

#### iOS

Edit `ios/Runner/AppDelegate.swift` and replace `your_api_key` with your actual API key:

```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY")
```

#### Android

Edit `android/app/src/main/AndroidManifest.xml` and add your API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY"/>
```

### 2. Get a Google Maps API Key

If you don't have a Google Maps API key:

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Maps SDK for Android** and **Maps SDK for iOS**
4. Create credentials (API Key)
5. Copy the API key and paste it in the files mentioned above

### 3. Run the Example

```bash
flutter pub get
flutter run
```

## Code Overview

### Main Components

**`_createMarkers()`** - Creates two custom markers:
- Caches the SVG asset first using `cacheSvg()`
- Creates an icon-based marker using `createIcon()`
- Creates an SVG-based marker using `createIcon()`

**`_locationMarker()`** - Builds a widget for the location icon marker:
- Circular amber container
- White location icon

**`_svgMarker()`** - Builds a widget for the SVG marker:
- Circular amber container
- SVG user icon with white color filter

### Key Takeaways

1. **Always cache SVG assets before creating markers:**
   ```dart
   await _hybridMapMarker.cacheSvg(path: 'assets/user.svg');
   ```

2. **Create markers from any widget:**
   ```dart
   final icon = await _hybridMapMarker.createIcon(
     yourWidget,
     size: Size(64, 64),
   );
   ```

3. **Use the markers in Google Maps:**
   ```dart
   Marker(
     markerId: MarkerId('my-marker'),
     position: LatLng(lat, lng),
     icon: icon,
   );
   ```

## Assets

The example uses an SVG asset located at `assets/user.svg`. Make sure your `pubspec.yaml` includes:

```yaml
flutter:
  assets:
    - assets/
```

## Learn More

For more information about the `hybrid_map_marker` package, check the main [README](../README.md).
