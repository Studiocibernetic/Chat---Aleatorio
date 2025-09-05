import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EvidenceSection extends StatelessWidget {
  final bool includeMessageHistory;
  final Function(bool) onMessageHistoryToggle;
  final VoidCallback onAttachScreenshot;
  final bool hasScreenshot;

  const EvidenceSection({
    Key? key,
    required this.includeMessageHistory,
    required this.onMessageHistoryToggle,
    required this.onAttachScreenshot,
    required this.hasScreenshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidence (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 2.h),

        // Screenshot attachment
        GestureDetector(
          onTap: onAttachScreenshot,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: hasScreenshot
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: hasScreenshot ? 'check_circle' : 'camera_alt',
                    color: hasScreenshot
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasScreenshot
                            ? 'Screenshot Attached'
                            : 'Attach Screenshot',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: hasScreenshot
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                      ),
                      Text(
                        hasScreenshot
                            ? 'Tap to change screenshot'
                            : 'Add visual evidence of the issue',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Message history inclusion
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Include Message History',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Share conversation context with moderators',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: includeMessageHistory,
                onChanged: (value) => onMessageHistoryToggle(value ?? false),
                activeColor: AppTheme.lightTheme.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
