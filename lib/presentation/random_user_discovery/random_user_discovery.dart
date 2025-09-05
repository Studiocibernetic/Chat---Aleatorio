import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/match_preferences_panel_widget.dart';
import './widgets/matching_animation_widget.dart';
import './widgets/queue_position_widget.dart';
import './widgets/quick_match_card_widget.dart';

class RandomUserDiscovery extends StatefulWidget {
  const RandomUserDiscovery({super.key});

  @override
  State<RandomUserDiscovery> createState() => _RandomUserDiscoveryState();
}

class _RandomUserDiscoveryState extends State<RandomUserDiscovery>
    with TickerProviderStateMixin {
  // Filter states
  bool _ageFilterSelected = false;
  bool _countryFilterSelected = false;
  bool _languageFilterSelected = false;
  int _ageFilterCount = 0;
  int _countryFilterCount = 0;
  int _languageFilterCount = 0;

  // Matching states
  bool _isMatching = false;
  bool _showQueue = false;
  String _matchingMessage = 'Toque em "Buscar Parceiro" para começar';

  // Preferences panel
  bool _preferencesExpanded = false;
  bool _ageFilterEnabled = true;
  String _selectedCountry = 'BR';
  List<String> _selectedLanguages = ['pt'];

  // Quick match selection
  String _selectedQuickMatch = '';

  // Queue information
  int _queuePosition = 0;
  int _estimatedWaitMinutes = 0;
  int _onlineUsersCount = 1247;

  // Mock data for filters and matching
  final List<Map<String, dynamic>> _mockFilters = [
    {"type": "age", "label": "18-25 anos", "count": 342},
    {"type": "age", "label": "26-35 anos", "count": 567},
    {"type": "age", "label": "36-45 anos", "count": 234},
    {"type": "country", "label": "Brasil", "count": 456},
    {"type": "country", "label": "EUA", "count": 234},
    {"type": "country", "label": "Reino Unido", "count": 123},
    {"type": "language", "label": "Português", "count": 678},
    {"type": "language", "label": "Inglês", "count": 543},
    {"type": "language", "label": "Espanhol", "count": 321},
  ];

  final List<Map<String, dynamic>> _quickMatchOptions = [
    {
      "id": "anyone",
      "title": "Qualquer Pessoa",
      "description": "Conectar com qualquer usuário online",
      "icon": "public",
    },
    {
      "id": "same_country",
      "title": "Mesmo País",
      "description": "Pessoas do seu país",
      "icon": "flag",
    },
    {
      "id": "language_practice",
      "title": "Prática de Idioma",
      "description": "Conversar em outros idiomas",
      "icon": "translate",
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateFilterCounts();
  }

  void _updateFilterCounts() {
    setState(() {
      _ageFilterCount = _ageFilterSelected ? 2 : 0;
      _countryFilterCount = _countryFilterSelected ? 1 : 0;
      _languageFilterCount = _languageFilterSelected ? 3 : 0;
    });
  }

  void _applyFilters() {
    setState(() {
      _isMatching = true;
      _showQueue = false;
      _matchingMessage = 'Aplicando filtros e buscando parceiro...';
    });

    // Simulate filter application and queue entry
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showQueue = true;
          _queuePosition = 15;
          _estimatedWaitMinutes = 3;
          _matchingMessage = 'Procurando seu parceiro de chat...';
        });
      }
    });

    // Simulate finding a match
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        _simulateMatchFound();
      }
    });
  }

  void _startRandomChat() {
    setState(() {
      _isMatching = true;
      _showQueue = false;
      _matchingMessage = 'Conectando com usuário aleatório...';
    });

    // Simulate quick matching
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _simulateMatchFound();
      }
    });
  }

  void _simulateMatchFound() {
    setState(() {
      _isMatching = false;
      _showQueue = false;
      _matchingMessage = 'Parceiro encontrado! Redirecionando...';
    });

    // Navigate to chat interface
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushNamed(context, '/main-chat-interface');
      }
    });
  }

  void _retryMatching() {
    setState(() {
      _isMatching = false;
      _showQueue = false;
      _matchingMessage = 'Toque em "Buscar Parceiro" para tentar novamente';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Descobrir Usuários',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/recent-chats-list');
            },
            icon: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Section
            Container(
              padding: EdgeInsets.all(4.w),
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtros de Busca',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChipWidget(
                          label: 'Faixa Etária',
                          isSelected: _ageFilterSelected,
                          count: _ageFilterCount,
                          onTap: () {
                            setState(() {
                              _ageFilterSelected = !_ageFilterSelected;
                              _updateFilterCounts();
                            });
                          },
                        ),
                        SizedBox(width: 2.w),
                        FilterChipWidget(
                          label: 'País',
                          isSelected: _countryFilterSelected,
                          count: _countryFilterCount,
                          onTap: () {
                            setState(() {
                              _countryFilterSelected = !_countryFilterSelected;
                              _updateFilterCounts();
                            });
                          },
                        ),
                        SizedBox(width: 2.w),
                        FilterChipWidget(
                          label: 'Idioma',
                          isSelected: _languageFilterSelected,
                          count: _languageFilterCount,
                          onTap: () {
                            setState(() {
                              _languageFilterSelected =
                                  !_languageFilterSelected;
                              _updateFilterCounts();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_ageFilterSelected ||
                              _countryFilterSelected ||
                              _languageFilterSelected)
                          ? _applyFilters
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Aplicar Filtros',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Matching Animation Section
            MatchingAnimationWidget(
              isMatching: _isMatching,
              message: _matchingMessage,
            ),

            // Queue Position (when visible)
            if (_showQueue) ...[
              SizedBox(height: 2.h),
              QueuePositionWidget(
                position: _queuePosition,
                estimatedWaitMinutes: _estimatedWaitMinutes,
                onlineUsersCount: _onlineUsersCount,
              ),
            ],

            SizedBox(height: 3.h),

            // Match Preferences Panel
            MatchPreferencesPanelWidget(
              isExpanded: _preferencesExpanded,
              ageFilterEnabled: _ageFilterEnabled,
              selectedCountry: _selectedCountry,
              selectedLanguages: _selectedLanguages,
              onToggleExpanded: () {
                setState(() {
                  _preferencesExpanded = !_preferencesExpanded;
                });
              },
              onAgeFilterChanged: (value) {
                setState(() {
                  _ageFilterEnabled = value;
                });
              },
              onCountryChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                });
              },
              onLanguagesChanged: (value) {
                setState(() {
                  _selectedLanguages = value;
                });
              },
            ),

            SizedBox(height: 3.h),

            // Quick Match Options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Opções Rápidas',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 20.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _quickMatchOptions.length,
                      itemBuilder: (context, index) {
                        final option = _quickMatchOptions[index];
                        return QuickMatchCardWidget(
                          title: option['title'] as String,
                          description: option['description'] as String,
                          iconName: option['icon'] as String,
                          isSelected: _selectedQuickMatch == option['id'],
                          onTap: () {
                            setState(() {
                              _selectedQuickMatch =
                                  _selectedQuickMatch == option['id']
                                      ? ''
                                      : option['id'] as String;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Start Random Chat Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isMatching ? null : _startRandomChat,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isMatching) ...[
                        SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.w),
                      ] else ...[
                        CustomIconWidget(
                          iconName: 'flash_on',
                          color: Colors.white,
                          size: 6.w,
                        ),
                        SizedBox(width: 2.w),
                      ],
                      Text(
                        _isMatching
                            ? 'Buscando...'
                            : 'Buscar Parceiro Aleatório',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Online Users Count
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '$_onlineUsersCount usuários online',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Discover tab active
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'chat_bubble',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'explore_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'explore',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Descobrir',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/recent-chats-list');
              break;
            case 1:
              // Already on discover screen
              break;
            case 2:
              // Navigate to profile (not implemented in this scope)
              break;
          }
        },
      ),
    );
  }
}
