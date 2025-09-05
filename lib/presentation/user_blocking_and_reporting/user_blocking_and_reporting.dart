import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/block_user_toggle.dart';
import './widgets/evidence_section.dart';
import './widgets/report_reason_selector.dart';
import './widgets/reported_user_info.dart';
import './widgets/safety_guidelines_section.dart';

class UserBlockingAndReporting extends StatefulWidget {
  const UserBlockingAndReporting({Key? key}) : super(key: key);

  @override
  State<UserBlockingAndReporting> createState() =>
      _UserBlockingAndReportingState();
}

class _UserBlockingAndReportingState extends State<UserBlockingAndReporting> {
  String? selectedReason;
  bool isUserBlocked = false;
  bool includeMessageHistory = false;
  bool hasScreenshot = false;
  bool isSubmitting = false;
  bool showQuickBlock = false;

  final TextEditingController otherReasonController = TextEditingController();

  // Mock user data
  final Map<String, dynamic> reportedUserData = {
    "identifier": "Anonymous_Butterfly_7429",
    "lastInteraction": DateTime.now().subtract(Duration(minutes: 15)),
  };

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
  }

  bool get canSubmitReport {
    if (selectedReason == null) return false;
    if (selectedReason == 'Other' &&
        otherReasonController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void _onReasonSelected(String reason) {
    setState(() {
      selectedReason = reason;
      if (reason != 'Other') {
        otherReasonController.clear();
      }
    });
  }

  void _onBlockToggle(bool value) {
    setState(() {
      isUserBlocked = value;
    });

    if (value) {
      HapticFeedback.lightImpact();
      _showBlockConfirmation();
    }
  }

  void _showBlockConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User has been blocked successfully'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onMessageHistoryToggle(bool value) {
    setState(() {
      includeMessageHistory = value;
    });
  }

  void _onAttachScreenshot() {
    // Simulate screenshot attachment
    setState(() {
      hasScreenshot = !hasScreenshot;
    });

    HapticFeedback.selectionClick();

    final message = hasScreenshot
        ? 'Screenshot attached successfully'
        : 'Screenshot removed';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (!canSubmitReport) return;

    setState(() {
      isSubmitting = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        isSubmitting = false;
      });

      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 48,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Report Submitted',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Thank you for helping keep our community safe. We will review your report and take appropriate action.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _quickBlock() {
    setState(() {
      isUserBlocked = true;
      showQuickBlock = false;
    });

    HapticFeedback.mediumImpact();
    _showBlockConfirmation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Report & Block User',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
        ),
        actions: [
          if (!showQuickBlock)
            TextButton(
              onPressed: () {
                setState(() {
                  showQuickBlock = true;
                });
              },
              child: Text(
                'Quick Block',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick block banner
                  if (showQuickBlock) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'block',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quick Block Available',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppTheme.lightTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  'Block immediately without filing a report',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.lightTheme.primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _quickBlock,
                            child: Text(
                              'Block Now',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Reported user info
                  ReportedUserInfo(
                    userIdentifier: reportedUserData["identifier"] as String,
                    interactionTime:
                        reportedUserData["lastInteraction"] as DateTime,
                  ),

                  SizedBox(height: 3.h),

                  // Report reason selector
                  ReportReasonSelector(
                    selectedReason: selectedReason,
                    onReasonSelected: _onReasonSelected,
                    otherReasonController: otherReasonController,
                  ),

                  SizedBox(height: 3.h),

                  // Block user toggle
                  BlockUserToggle(
                    isBlocked: isUserBlocked,
                    onToggle: _onBlockToggle,
                  ),

                  SizedBox(height: 3.h),

                  // Evidence section
                  EvidenceSection(
                    includeMessageHistory: includeMessageHistory,
                    onMessageHistoryToggle: _onMessageHistoryToggle,
                    onAttachScreenshot: _onAttachScreenshot,
                    hasScreenshot: hasScreenshot,
                  ),

                  SizedBox(height: 3.h),

                  // Safety guidelines
                  SafetyGuidelinesSection(),

                  SizedBox(height: 10.h), // Space for bottom button
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed:
                      canSubmitReport && !isSubmitting ? _submitReport : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSubmitReport
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppTheme
                        .lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    disabledForegroundColor:
                        AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: canSubmitReport ? 2 : 0,
                  ),
                  child: isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Submitting Report...',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        )
                      : Text(
                          'Submit Report',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: canSubmitReport
                                        ? Colors.white
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
