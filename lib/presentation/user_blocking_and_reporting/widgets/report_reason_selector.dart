import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ReportReasonSelector extends StatefulWidget {
  final String? selectedReason;
  final Function(String) onReasonSelected;
  final TextEditingController otherReasonController;

  const ReportReasonSelector({
    Key? key,
    required this.selectedReason,
    required this.onReasonSelected,
    required this.otherReasonController,
  }) : super(key: key);

  @override
  State<ReportReasonSelector> createState() => _ReportReasonSelectorState();
}

class _ReportReasonSelectorState extends State<ReportReasonSelector> {
  final List<String> reportReasons = [
    'Harassment',
    'Inappropriate Content',
    'Spam',
    'Fake Profile',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Report',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 2.h),
        ...reportReasons
            .map((reason) => Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: RadioListTile<String>(
                    value: reason,
                    groupValue: widget.selectedReason,
                    onChanged: (value) {
                      if (value != null) {
                        widget.onReasonSelected(value);
                      }
                    },
                    title: Text(
                      reason,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                    dense: true,
                    activeColor: AppTheme.lightTheme.primaryColor,
                  ),
                ))
            .toList(),
        if (widget.selectedReason == 'Other') ...[
          SizedBox(height: 2.h),
          TextField(
            controller: widget.otherReasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Please describe the issue...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
