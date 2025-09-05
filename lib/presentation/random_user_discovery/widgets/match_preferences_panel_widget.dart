import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchPreferencesPanelWidget extends StatelessWidget {
  final bool isExpanded;
  final bool ageFilterEnabled;
  final String selectedCountry;
  final List<String> selectedLanguages;
  final VoidCallback onToggleExpanded;
  final ValueChanged<bool> onAgeFilterChanged;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<List<String>> onLanguagesChanged;

  const MatchPreferencesPanelWidget({
    super.key,
    required this.isExpanded,
    required this.ageFilterEnabled,
    required this.selectedCountry,
    required this.selectedLanguages,
    required this.onToggleExpanded,
    required this.onAgeFilterChanged,
    required this.onCountryChanged,
    required this.onLanguagesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> countries = [
      {"name": "Brasil", "code": "BR", "flag": "🇧🇷"},
      {"name": "Estados Unidos", "code": "US", "flag": "🇺🇸"},
      {"name": "Reino Unido", "code": "GB", "flag": "🇬🇧"},
      {"name": "Espanha", "code": "ES", "flag": "🇪🇸"},
      {"name": "França", "code": "FR", "flag": "🇫🇷"},
      {"name": "Alemanha", "code": "DE", "flag": "🇩🇪"},
      {"name": "Itália", "code": "IT", "flag": "🇮🇹"},
      {"name": "Japão", "code": "JP", "flag": "🇯🇵"},
    ];

    final List<Map<String, dynamic>> languages = [
      {"name": "Português", "code": "pt", "native": "Português"},
      {"name": "Inglês", "code": "en", "native": "English"},
      {"name": "Espanhol", "code": "es", "native": "Español"},
      {"name": "Francês", "code": "fr", "native": "Français"},
      {"name": "Alemão", "code": "de", "native": "Deutsch"},
      {"name": "Italiano", "code": "it", "native": "Italiano"},
      {"name": "Japonês", "code": "ja", "native": "日本語"},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggleExpanded,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Preferências de Busca',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Age Filter Toggle
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filtrar por Idade',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Buscar pessoas em faixa etária similar',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: ageFilterEnabled,
                        onChanged: onAgeFilterChanged,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Country Selection
                  Text(
                    'País Preferido',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCountry.isEmpty ? null : selectedCountry,
                        hint: Text(
                          'Selecionar país',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        isExpanded: true,
                        items: [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text('Qualquer país'),
                          ),
                          ...countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['code'] as String,
                              child: Row(
                                children: [
                                  Text(
                                    country['flag'] as String,
                                    style: TextStyle(fontSize: 5.w),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(country['name'] as String),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) => onCountryChanged(value ?? ''),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Language Selection
                  Text(
                    'Idiomas Preferidos',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: languages.map((language) {
                      final isSelected =
                          selectedLanguages.contains(language['code']);
                      return GestureDetector(
                        onTap: () {
                          List<String> newSelection =
                              List.from(selectedLanguages);
                          if (isSelected) {
                            newSelection.remove(language['code']);
                          } else {
                            newSelection.add(language['code'] as String);
                          }
                          onLanguagesChanged(newSelection);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                language['name'] as String,
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              if (isSelected) ...[
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 4.w,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
