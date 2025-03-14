/// Loading effect styles for the bar progress indicator
enum NovaBarLoadingEffect {
  /// Bars fill sequentially from start to end
  sequential,

  /// Bars fill randomly
  random,

  /// Bars fill from center outward
  fromCenter,

  /// Bars fill from both ends toward center
  fromEnds,

  /// Digital/binary-like filling pattern
  digital,

  /// Terminal-style loading pattern with flickering
  terminal,
}
