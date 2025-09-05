import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isSent;
  final DateTime timestamp;
  final String deliveryStatus;
  final VoidCallback? onLongPress;
  final VoidCallback? onReply;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isSent,
    required this.timestamp,
    required this.deliveryStatus,
    this.onLongPress,
    this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment:
              isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSent) ...[
              CircleAvatar(
                radius: 4.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                  size: 4.w,
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSent
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(isSent ? 18 : 4),
                    bottomRight: Radius.circular(isSent ? 4 : 18),
                  ),
                  border: !isSent
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSent
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(timestamp),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isSent
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                    .withValues(alpha: 0.7)
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                        ),
                        if (isSent) ...[
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: _getDeliveryIcon(deliveryStatus),
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.7),
                            size: 3.w,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isSent) ...[
              SizedBox(width: 2.w),
              CircleAvatar(
                radius: 4.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 4.w,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getDeliveryIcon(String status) {
    switch (status) {
      case 'sent':
        return 'check';
      case 'delivered':
        return 'done_all';
      case 'read':
        return 'done_all';
      default:
        return 'schedule';
    }
  }
}
