import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  static const int minTabletWidth = 600;
  static const int minTabletLargeWidth = 900;
  static const int minDesktopWidth = 1200;

  static Size _getCurrentScreenSize(BuildContext context) => MediaQuery.of(context).size;

  static Orientation _getCurrentScreenOrientation(BuildContext context) => MediaQuery.of(context).orientation;

  static bool _isPortrait(BuildContext context) => _getCurrentScreenOrientation(context) == Orientation.portrait;

  static bool _isLandscape(BuildContext context) => _getCurrentScreenOrientation(context) == Orientation.landscape;

  static bool isLandscapeMobile(BuildContext context) => _getCurrentScreenSize(context).shortestSide < minTabletWidth && _isLandscape(context);

  static bool isPortraitMobile(BuildContext context) => _getCurrentScreenSize(context).shortestSide < minTabletWidth && _isPortrait(context);

  static bool isMobile(BuildContext context) => isPortraitMobile(context) || isLandscapeMobile(context);

  static bool isTablet(BuildContext context) => _getCurrentScreenSize(context).width >= minTabletWidth && _getCurrentScreenSize(context).width < minTabletLargeWidth;

  static isTabletLarge(BuildContext context) => _getCurrentScreenSize(context).width >= minTabletLargeWidth && _getCurrentScreenSize(context).width < minDesktopWidth;

  static bool isDesktop(BuildContext context) => _getCurrentScreenSize(context).width >= minDesktopWidth;
}
