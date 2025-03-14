/// The size variants available for [NovaButton]
enum NovaButtonSize {
  /// Small button for compact UIs (100x40)
  small,

  /// Medium button for standard UIs (150x50)
  medium,

  /// Large button for prominent actions (200x60)
  large,

  /// Wide button that spans containers (match parent width × 50)
  wide,

  /// Tiny round button for icon actions (40x40)
  icon,
}

// Get the dimensions based on the selected size
Map<String, dynamic> getDimensions(NovaButtonSize size, double? borderRadius) {
  switch (size) {
    case NovaButtonSize.small:
      return {
        'width': 100.0,
        'height': 40.0,
        'fontSize': 14.0,
        'iconSize': 16.0,
        'borderRadius': borderRadius ?? 6.0,
      };
    case NovaButtonSize.medium:
      return {
        'width': 150.0,
        'height': 50.0,
        'fontSize': 16.0,
        'iconSize': 20.0,
        'borderRadius': borderRadius ?? 8.0,
      };
    case NovaButtonSize.large:
      return {
        'width': 200.0,
        'height': 60.0,
        'fontSize': 18.0,
        'iconSize': 24.0,
        'borderRadius': borderRadius ?? 10.0,
      };
    case NovaButtonSize.wide:
      return {
        'width': double.infinity,
        'height': 50.0,
        'fontSize': 16.0,
        'iconSize': 20.0,
        'borderRadius': borderRadius ?? 8.0,
      };
    case NovaButtonSize.icon:
      return {
        'width': 40.0,
        'height': 40.0,
        'fontSize': 0.0,
        'iconSize': 24.0,
        'borderRadius': borderRadius ?? 20.0,
      };
  }
}
