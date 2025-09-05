import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AnonymousAvatarWidget extends StatelessWidget {
  final Color avatarColor;
  final String pattern;

  const AnonymousAvatarWidget({
    Key? key,
    required this.avatarColor,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: avatarColor.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: avatarColor,
          width: 3,
        ),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: pattern,
          color: avatarColor,
          size: 12.w,
        ),
      ),
    );
  }
}
