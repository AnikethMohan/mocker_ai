import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileView;
  final Widget? tabletView;
  final Widget desktopView;

  const ResponsiveLayout({
    super.key,
    required this.mobileView,
    this.tabletView,
    required this.desktopView,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktopView;
        } else if (constraints.maxWidth >= 800 && constraints.maxWidth < 1200) {
          return tabletView ?? desktopView;
        } else {
          return mobileView;
        }
      },
    );
  }
}

double get screenWidth {
  if (isDesktop || isTablet) {
    return desktopScreenWidth;
  }
  return Get.width;
}

final isDesktop = Get.width > 800;

final double desktopScreenWidth = Get.width * 0.5;

final bool isTablet =
    !kIsWeb && Get.size.shortestSide >= 600 && Get.size.longestSide <= 1300;
