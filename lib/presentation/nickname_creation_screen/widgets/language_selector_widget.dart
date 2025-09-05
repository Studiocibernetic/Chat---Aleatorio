import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageSelected;
  final bool isEnabled;

  const LanguageSelectorWidget({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
    this.isEnabled = true,
  }) : super(key: key);

  static const Map<String, Map<String, String>> languages = {
    'pt': {'name': 'Português', 'flag': '🇧🇷'},
    'en': {'name': 'English', 'flag': '🇺🇸'},
    'es': {'name': 'Español', 'flag': '🇪🇸'},
    'fr': {'name': 'Français', 'flag': '🇫🇷'},
    'de': {'name': 'Deutsch', 'flag': '🇩🇪'},
    'it': {'name': 'Italiano', 'flag': '🇮🇹'},
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Idioma preferido',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: theme.colorScheme.onSurface,
                size: 6.w,
              ),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: theme.colorScheme.surface,
              items: languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  enabled: isEnabled,
                  child: Row(
                    children: [
                      Text(
                        entry.value['flag']!,
                        style: TextStyle(fontSize: 6.w),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        entry.value['name']!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isEnabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: isEnabled
                  ? (String? newValue) {
                      if (newValue != null) {
                        onLanguageSelected(newValue);
                      }
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
