final baseWidth = 411.42857142857144;
final baseHeight = 843.4285714285714;
final basePixelRatio = 2.625;

class ResponsiveSize {
  static double devicePixelRatio;

  static double flexHeight(double value, deviceHeight) {
    return value * deviceHeight / baseHeight;
  }

  static double flexWidth(double value, deviceWidth) {
    return value * deviceWidth / baseWidth;
  }

  static double flexSize(double value, double pixelRatio) {
    return value * basePixelRatio / devicePixelRatio;
  }
}
