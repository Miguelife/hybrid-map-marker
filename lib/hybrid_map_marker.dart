import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A utility class for creating custom map markers from Flutter widgets.
///
/// This class provides functionality to convert Flutter widgets into bitmap
/// descriptors that can be used as custom markers in Google Maps.
/// It uses a singleton pattern to ensure consistent marker creation.
///
/// Example:
/// ```dart
/// final marker = await HybridMapMarkerImpl.instance.createIcon(
///   Icon(Icons.location_on, size: 48),
///   size: Size(48, 48),
/// );
/// ```
abstract interface class HybridMapMarker {
  /// **Important:** This method must be called before [createIcon] if the widget
  /// contains SVG images. Otherwise, the SVG may not render correctly in the
  /// generated marker icon.
  ///
  /// Parameters:
  ///   - [path]: The asset path to the SVG file (e.g., 'assets/marker.svg')
  ///
  /// Example:
  /// ```dart
  /// // Cache the SVG before creating the icon
  /// await HybridMapMarkerImpl.instance.cacheSvg(path: 'assets/marker.svg');
  ///
  /// // Now create the icon with the SVG
  /// final marker = await HybridMapMarkerImpl.instance.createIcon(
  ///   SvgPicture.asset('assets/marker.svg'),
  ///   size: Size(48, 48),
  /// );
  /// ```
  Future<void> cacheSvg({required String path});

  /// **Important:** This method must be called before [createIcon] if the widget
  /// contains asset images. Otherwise, the image may not render correctly in the
  /// generated marker icon.
  ///
  /// Parameters:
  ///   - [path]: The asset path to the image file (e.g., 'assets/marker.png')
  ///
  /// Example:
  /// ```dart
  /// // Cache the image before creating the icon
  /// await HybridMapMarkerImpl.instance.cacheImage(path: 'assets/marker.png');
  ///
  /// // Now create the icon with the image
  /// final marker = await HybridMapMarkerImpl.instance.createIcon(
  ///   Image.asset('assets/marker.png'),
  ///   size: Size(48, 48),
  /// );
  /// ```
  Future<void> cacheImage({required String path});

  /// **Important:** This method must be called before [createIcon] if the widget
  /// contains network images. Otherwise, the image may not render correctly in the
  /// generated marker icon.
  ///
  /// Parameters:
  ///   - [path]: The URL of the network image (e.g., 'https://example.com/marker.png')
  ///
  /// Example:
  /// ```dart
  /// // Cache the network image before creating the icon
  /// await HybridMapMarkerImpl.instance.cacheNetworkImage(
  ///   path: 'https://example.com/marker.png',
  /// );
  ///
  /// // Now create the icon with the network image
  /// final marker = await HybridMapMarkerImpl.instance.createIcon(
  ///   Image.network('https://example.com/marker.png'),
  ///   size: Size(48, 48),
  /// );
  /// ```
  Future<void> cacheNetworkImage({required String path});

  /// Converts a Flutter widget into a [BitmapDescriptor] for use as a map marker.
  ///
  /// This method renders the provided widget into a bitmap image that can be used
  /// as a custom marker icon in Google Maps. The rendering process creates an
  /// off-screen render tree to generate the image.
  ///
  /// Parameters:
  ///   - [widget]: The Flutter widget to convert into a marker icon
  ///   - [size]: The logical size of the marker in logical pixels
  ///   - [quality]: A multiplier for the device pixel ratio (default: 1.0).
  ///                Higher values produce sharper images but use more memory.
  ///
  /// Returns:
  ///   A [Future] that completes with a [BitmapDescriptor] containing the
  ///   rendered widget as a bitmap image.
  ///
  /// Example:
  /// ```dart
  /// final marker = await HybridMapMarkerImpl.instance.createIcon(
  ///   Container(
  ///     decoration: BoxDecoration(
  ///       color: Colors.red,
  ///       shape: BoxShape.circle,
  ///     ),
  ///     child: Icon(Icons.person, color: Colors.white),
  ///   ),
  ///   size: Size(100, 100),
  ///   quality: 2.0,
  /// );
  /// ```
  Future<BitmapDescriptor> createIcon(
    Widget widget, {
    required Size size,
    double quality = 1.0,
  });
}
