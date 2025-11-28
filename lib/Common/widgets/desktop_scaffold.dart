import 'package:flutter/material.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({
    super.key,
    required this.child,

    this.rightChild,
    this.leftChild,
    this.hideDrawer = false,
    this.childWidth,
    this.childAlignMent,
    this.borderRadius,
    this.padding,
    this.isExpanded = false,
    this.showChildBorder = true,
  });

  final Widget child;
  final Widget? leftChild;
  final Widget? rightChild;
  final bool hideDrawer;
  final double? childWidth;
  final MainAxisAlignment? childAlignMent;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final bool isExpanded;
  final bool showChildBorder;

  ///Called when studio is changed

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  //final _sc = Get.put(DashBoardController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isTablet = size.width > 600 && size.width < 1024;
    return ClipRRect(
      // borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Row(
          children: [
            // if (!widget.hideDrawer && !(size.width >= 600 && size.width < 1024))
            //   SizedBox(
            //     width: isTablet ? 250.: 380,
            //     child: ValueListenableBuilder(
            //       valueListenable: AppNavigationNotifier.appNavigation,
            //       builder: (context, value, child) {
            //         List<AppNavigation> sortedNavItems =
            //             [
            //               ...(navItems?.isNotEmpty == true &&
            //                       AppNavigationNotifier.navItemChanged.value ==
            //                           false
            //                   ? navItems ?? []
            //                   : (AppNavigationNotifier.appNavigation.value ??
            //                         [])),
            //             ]..sort((a, b) {
            //               if (a.index == null && b.index == null) return 0;
            //               if (a.index == null) return 1;
            //               if (b.index == null) return -1;
            //               return a.index?.compareTo(b.index ?? 0) ?? 0;
            //             });

            //         return AppSideDrawer(
            //           onStudioSwitch: widget.onStudioSwitch,
            //           sideDrawerItems: [
            //             ...sortedNavItems.map((e) {
            //               return AppSideDrawerItem(
            //                 label: e.label ?? '',
            //                 icon: BrandIconsData.fromCode(e.icon),
            //                 activeIcon: BrandIconsData.fromCode(e.activeIcon),
            //                 route: e.route ?? '',
            //                 studioSelectManditory:
            //                     e.studioSelectManditory ?? false,
            //                 enabled: e.enabled ?? true,
            //               );
            //             }),
            //             // AppSideDrawerItem(
            //             //   label: 'Addresses',
            //             //   icon: BrandIcons.icon_calender,
            //             //   activeIcon: BrandIcons.icon_calender,
            //             //   route: RoutesName.fitShopViewAdresses,
            //             //   studioSelectManditory: false,
            //             //   enabled: true,
            //             // ),
            //           ],
            //         );
            //       },
            //     ),
            //   ),
            Row(
              mainAxisAlignment:
                  widget.childAlignMent ?? MainAxisAlignment.center,
              children: [
                if (widget.leftChild != null) widget.leftChild ?? SizedBox(),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.3),
                    decoration: BoxDecoration(
                      border: Border.symmetric(vertical: BorderSide()),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.3),

                    // padding: EdgeInsets.only(
                    //   top: 40,
                    //   left: 0,
                    //   // right: !hideDrawer ? 100 : 0,
                    // ),
                    width: widget.childWidth ?? size.width * 0.5,
                    child: widget.child,
                  ),
                ),
                if (widget.rightChild != null) widget.rightChild ?? SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
