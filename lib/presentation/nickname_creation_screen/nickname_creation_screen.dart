import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/age_range_selector_widget.dart';
import './widgets/anonymous_avatar_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/nickname_input_widget.dart';
import './widgets/privacy_message_widget.dart';

class NicknameCreationScreen extends StatefulWidget {
  const NicknameCreationScreen({Key? key}) : super(key: key);

  @override
  State<NicknameCreationScreen> createState() => _NicknameCreationScreenState();
}

class _NicknameCreationScreenState extends State<NicknameCreationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _nicknameFocusNode = FocusNode();

  String? _selectedAgeRange;
  String _selectedLanguage = 'pt';
  String? _errorText;
  bool _isLoading = false;
  bool _isValidating = false;

  // Avatar randomization
  late Color _avatarColor;
  late String _avatarPattern;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock data for validation
  final List<String> _bannedNames = [
    'admin',
    'moderator',
    'support',
    'help',
    'bot',
    'system',
    'joão',
    'maria',
    'pedro',
    'ana',
    'carlos',
    'josé'
  ];

  final List<String> _profanityWords = [
    'idiota',
    'burro',
    'estúpido',
    'imbecil'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateRandomAvatar();
    _nicknameController.addListener(_onNicknameChanged);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _generateRandomAvatar() {
    final colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
      const Color(0xFF9C27B0),
      const Color(0xFFFF5722),
      const Color(0xFF607D8B),
    ];

    final patterns = [
      'person',
      'face',
      'account_circle',
      'sentiment_satisfied',
      'psychology',
      'emoji_emotions'
    ];

    setState(() {
      _avatarColor = colors[DateTime.now().millisecond % colors.length];
      _avatarPattern = patterns[DateTime.now().second % patterns.length];
    });
  }

  void _onNicknameChanged() {
    if (_isValidating) return;

    setState(() {
      _errorText = null;
    });

    if (_nicknameController.text.isNotEmpty) {
      _validateNickname(_nicknameController.text);
    }
  }

  Future<void> _validateNickname(String nickname) async {
    if (nickname.isEmpty) return;

    setState(() {
      _isValidating = true;
    });

    // Simulate validation delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    String? error;

    // Check minimum length
    if (nickname.length < 3) {
      error = 'Apelido deve ter pelo menos 3 caracteres';
    }
    // Check for real names
    else if (_bannedNames
        .any((name) => nickname.toLowerCase().contains(name.toLowerCase()))) {
      error = 'Evite usar nomes reais para manter o anonimato';
    }
    // Check for profanity
    else if (_profanityWords
        .any((word) => nickname.toLowerCase().contains(word.toLowerCase()))) {
      error = 'Por favor, escolha um apelido mais apropriado';
    }
    // Check uniqueness (simulated)
    else if (nickname.toLowerCase() == 'usuario123') {
      error = 'Este apelido já está em uso. Tente outro.';
    }

    setState(() {
      _errorText = error;
      _isValidating = false;
    });
  }

  bool get _isFormValid {
    return _nicknameController.text.length >= 3 &&
        _errorText == null &&
        !_isValidating;
  }

  Future<void> _startChatting() async {
    if (!_isFormValid || _isLoading) return;

    // Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate account creation
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Success haptic feedback
      HapticFeedback.mediumImpact();

      // Navigate to main chat interface
      Navigator.pushReplacementNamed(context, '/main-chat-interface');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorText = 'Erro ao criar conta. Tente novamente.';
      });

      // Error haptic feedback
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _skipForNow() async {
    // Generate auto nickname
    final autoNicknames = [
      'Usuário${DateTime.now().millisecond}',
      'Anônimo${DateTime.now().second}',
      'Chat${DateTime.now().minute}',
    ];

    final autoNickname =
        autoNicknames[DateTime.now().second % autoNicknames.length];

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/main-chat-interface');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // Header
                    Text(
                      'Crie seu Apelido',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Escolha como você quer ser conhecido nas conversas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 6.h),

                    // Anonymous Avatar
                    GestureDetector(
                      onTap: _generateRandomAvatar,
                      child: AnonymousAvatarWidget(
                        avatarColor: _avatarColor,
                        pattern: _avatarPattern,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      'Toque para gerar novo avatar',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // Nickname Input
                    NicknameInputWidget(
                      controller: _nicknameController,
                      onChanged: (value) {},
                      errorText: _errorText,
                      isLoading: _isValidating,
                    ),

                    SizedBox(height: 4.h),

                    // Age Range Selector
                    AgeRangeSelectorWidget(
                      selectedAgeRange: _selectedAgeRange,
                      onAgeRangeSelected: (ageRange) {
                        setState(() {
                          _selectedAgeRange =
                              _selectedAgeRange == ageRange ? null : ageRange;
                        });
                      },
                      isEnabled: !_isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Language Selector
                    LanguageSelectorWidget(
                      selectedLanguage: _selectedLanguage,
                      onLanguageSelected: (language) {
                        setState(() {
                          _selectedLanguage = language;
                        });
                      },
                      isEnabled: !_isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Privacy Message
                    const PrivacyMessageWidget(),

                    SizedBox(height: 6.h),

                    // Start Chatting Button
                    SizedBox(
                      width: double.infinity,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed:
                            _isFormValid && !_isLoading ? _startChatting : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid && !_isLoading
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.12),
                          foregroundColor: _isFormValid && !_isLoading
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.38),
                          elevation: _isFormValid && !_isLoading ? 2 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                'Começar a Conversar',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Skip Button
                    TextButton(
                      onPressed: _isLoading ? null : _skipForNow,
                      child: Text(
                        'Pular por agora',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
