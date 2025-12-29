import 'package:flutter/material.dart';

import 'package:get/utils.dart';
import 'package:mocker_ai/Common/Theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.avatarInitial,
    this.isActive = false,
    this.gradient = AppColors.profileGradient,
    this.diameter = 35,
  });
  final String avatarInitial;
  final bool isActive;
  final List<Color> gradient;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    var initial = avatarInitial[0].capitalize;
    return Stack(
      children: [
        Container(
          height: diameter,
          width: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: Center(
            child: Text(
              initial ?? '',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        if (isActive)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
