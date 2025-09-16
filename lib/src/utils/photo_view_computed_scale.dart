import 'dart:math' as math;
import 'dart:ui' show Size;

/// Abstract base class for different types of computed photo view scales.
/// Supports multiplication and division operations while maintaining type information.
abstract class PhotoViewComputedScale {
  const PhotoViewComputedScale({this.multiplier = 1.0});

  final double multiplier;

  /// Get the type identifier for this scale type
  String get type;

  /// Compute the actual scale value given the outer and child sizes
  double computeScale(Size outerSize, Size childSize);

  /// Create a new instance with the given multiplier
  PhotoViewComputedScale withMultiplier(double newMultiplier);

  PhotoViewComputedScale operator *(double multiplier) {
    return withMultiplier(this.multiplier * multiplier);
  }

  PhotoViewComputedScale operator /(double divider) {
    return withMultiplier(multiplier / divider);
  }

  @override
  bool operator ==(Object other) => identical(this, other) ||
      (other is PhotoViewComputedScale && runtimeType == other.runtimeType && multiplier == other.multiplier);

  @override
  int get hashCode => runtimeType.hashCode ^ multiplier.hashCode;

  @override
  String toString() => '$runtimeType(multiplier: $multiplier)';

  // Static factory methods for backward compatibility
  factory PhotoViewComputedScale.contained([double multiplier = 1.0]) =>
      PhotoViewComputedContainedScale(multiplier: multiplier);

  factory PhotoViewComputedScale.covered([double multiplier = 1.0]) =>
      PhotoViewComputedCoveredScale(multiplier: multiplier);

  factory PhotoViewComputedScale.custom(double scale) =>
      PhotoViewComputedCustomScale(multiplier: scale);
}

/// Constrained scale type that ensures the entire content fits within the view bounds
class PhotoViewComputedContainedScale extends PhotoViewComputedScale {
  const PhotoViewComputedContainedScale({double multiplier = 1.0}) : super(multiplier: multiplier);

  @override
  String get type => 'contained';

  @override
  double computeScale(Size outerSize, Size childSize) {
    final double imageWidth = childSize.width;
    final double imageHeight = childSize.height;
    final double screenWidth = outerSize.width;
    final double screenHeight = outerSize.height;

    return math.min(screenWidth / imageWidth, screenHeight / imageHeight) * multiplier;
  }

  @override
  PhotoViewComputedScale withMultiplier(double newMultiplier) =>
      PhotoViewComputedContainedScale(multiplier: newMultiplier);
}

/// Covered scale type that ensures the content covers the entire view bounds
class PhotoViewComputedCoveredScale extends PhotoViewComputedScale {
  const PhotoViewComputedCoveredScale({double multiplier = 1.0}) : super(multiplier: multiplier);

  @override
  String get type => 'covered';

  @override
  double computeScale(Size outerSize, Size childSize) {
    final double imageWidth = childSize.width;
    final double imageHeight = childSize.height;
    final double screenWidth = outerSize.width;
    final double screenHeight = outerSize.height;

    return math.max(screenWidth / imageWidth, screenHeight / imageHeight) * multiplier;
  }

  @override
  PhotoViewComputedScale withMultiplier(double newMultiplier) =>
      PhotoViewComputedCoveredScale(multiplier: newMultiplier);
}

/// Scaled type for absolute/custom scale values
class PhotoViewComputedCustomScale extends PhotoViewComputedScale {
  const PhotoViewComputedCustomScale({double multiplier = 1.0}) : super(multiplier: multiplier);

  @override
  String get type => 'scaled';

  @override
  double computeScale(Size outerSize, Size childSize) => multiplier;

  @override
  PhotoViewComputedScale withMultiplier(double newMultiplier) =>
      PhotoViewComputedCustomScale(multiplier: newMultiplier);
}
