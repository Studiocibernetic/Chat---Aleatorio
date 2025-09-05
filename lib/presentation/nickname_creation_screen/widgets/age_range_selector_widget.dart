import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AgeRangeSelectorWidget extends StatelessWidget {
  final String? selectedAgeRange;
  final Function(String) onAgeRangeSelected;
  final bool isEnabled;

  const AgeRangeSelectorWidget({
    Key? key,
    this.selectedAgeRange,
    required this.onAgeRangeSelected,
    this.isEnabled = true,
  }) : super(key: key);

  static const List<String> ageRanges = ['18-25', '26-35', '36-45', '45+'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Faixa etária (opcional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: ageRanges.map((ageRange) {
            final isSelected = selectedAgeRange == ageRange;
            return GestureDetector(
              onTap: isEnabled ? () => onAgeRangeSelected(ageRange) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  ageRange,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
