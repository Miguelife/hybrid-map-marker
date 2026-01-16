import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A utility class for creating custom map markers from Flutter widgets.
///
/// This class provides functionality to convert Flutter widgets into bitmap
/// descriptors that can be used as custom markers in Google Maps.
/// It uses a singleton pattern to ensure consistent marker creation.
///
/// Example:
/// ```dart
/// final marker = await HybridMapMarker.instance.createIcon(
///   Icon(Icons.location_on, size: 48),
///   size: Size(48, 48),
/// );
/// ```
class HybridMapMarker {
  const HybridMapMarker._();
  static final instance = HybridMapMarker._();

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
  /// await HybridMapMarker.instance.cacheSvg(path: 'assets/marker.svg');
  ///
  /// // Now create the icon with the SVG
  /// final marker = await HybridMapMarker.instance.createIcon(
  ///   SvgPicture.asset('assets/marker.svg'),
  ///   size: Size(48, 48),
  /// );
  /// ```
  Future<void> cacheSvg({required String path}) async {
    final picture = SvgPicture.asset(path);
    final loader = picture.bytesLoader as SvgLoader;
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }

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
  /// final marker = await HybridMapMarker.instance.createIcon(
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
  }) async {
    final view = ui.PlatformDispatcher.instance.views.first;
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    final devicePixelRatio = view.devicePixelRatio * quality;

    final RenderView renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(size),
        devicePixelRatio: devicePixelRatio,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
          container: repaintBoundary,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ),
        ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await repaintBoundary.toImage(
      pixelRatio: devicePixelRatio,
    );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    final Uint8List uint8List =
        byteData?.buffer.asUint8List() ?? Uint8List.fromList([]);
    return BitmapDescriptor.bytes(
      uint8List,
      imagePixelRatio: devicePixelRatio,
      height: size.height,
      width: size.width,
    );
  }
}
