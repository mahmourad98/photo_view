import 'dart:math' as math;
import 'dart:ui' show Size;

import "package:photo_view/src/utils/photo_view_computed_scale.dart";
import 'package:photo_view/src/utils/photo_view_scale_state.dart';

/// Given a [PhotoViewScaleState], returns a scale value considering [scaleBoundaries].
double getScaleForScaleState(
  PhotoViewScaleState scaleState,
  ScaleBoundaries scaleBoundaries,
) {
  switch (scaleState) {
    case PhotoViewScaleState.initial:
    case PhotoViewScaleState.zoomedIn:
    case PhotoViewScaleState.zoomedOut:
      return _clampSize(scaleBoundaries.initialScale, scaleBoundaries);
    case PhotoViewScaleState.covering:
      return _clampSize(_computeCoveringScale(scaleBoundaries.outerSize, scaleBoundaries.childSize), scaleBoundaries);
    case PhotoViewScaleState.originalSize:
      return _clampSize(1.0, scaleBoundaries);
  }
}

/// Internal class to wraps custom scale boundaries (min, max and initial)
/// Also, stores values regarding the two sizes: the container and teh child.
class ScaleBoundaries {
  const ScaleBoundaries(
    this._minScale,
    this._maxScale,
    this._initialScale,
    this.outerSize,
    this.childSize,
  );

  final PhotoViewComputedScale _minScale;
  final PhotoViewComputedScale _maxScale;
  final PhotoViewComputedScale _initialScale;
  final Size outerSize;
  final Size childSize;

  double get minScale {
    return _minScale.computeScale(outerSize, childSize);
  }

  double get maxScale {
    return _maxScale.computeScale(outerSize, childSize).clamp(minScale, double.infinity);
  }

  double get initialScale {
    return _initialScale.computeScale(outerSize, childSize).clamp(minScale, maxScale);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScaleBoundaries &&
          runtimeType == other.runtimeType &&
          _minScale == other._minScale &&
          _maxScale == other._maxScale &&
          _initialScale == other._initialScale &&
          outerSize == other.outerSize &&
          childSize == other.childSize);

  @override
  int get hashCode =>
      _minScale.hashCode ^ _maxScale.hashCode ^ _initialScale.hashCode ^ outerSize.hashCode ^ childSize.hashCode;
}


double _computeCoveringScale(Size outerSize, Size childSize) {
  final double imageWidth = childSize.width;
  final double imageHeight = childSize.height;
  final double screenWidth = outerSize.width;
  final double screenHeight = outerSize.height;

  return math.max(screenWidth / imageWidth, screenHeight / imageHeight);
}

double _clampSize(double size, ScaleBoundaries scaleBoundaries) {
  return size.clamp(scaleBoundaries.minScale, scaleBoundaries.maxScale);
}

/// Simple class to store a min and a max value
class CornersRange {
  const CornersRange(this.min, this.max);
  final double min;
  final double max;
}
