import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _showRetryButton = false;
  bool _isInitializing = true;
  String _loadingText = 'Iniciando Random Chat...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading rotation animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_loadingAnimationController);

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Hide system UI for immersive experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      // Simulate initialization tasks
      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _loadingText = 'Verificando sessão anônima...';
      });

      // Check anonymous session status
      final hasActiveSession = await _checkAnonymousSession();
      await Future.delayed(const Duration(milliseconds: 600));

      setState(() {
        _loadingText = 'Carregando preferências...';
      });

      // Load user preferences
      await _loadUserPreferences();
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _loadingText = 'Conectando ao servidor...';
      });

      // Initialize WebSocket connections
      final connectionSuccess = await _initializeWebSocket();
      await Future.delayed(const Duration(milliseconds: 700));

      if (!connectionSuccess) {
        _showConnectionError();
        return;
      }

      setState(() {
        _loadingText = 'Preparando dados...';
      });

      // Prepare cached chat data
      await _prepareCachedData();
      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        _isInitializing = false;
      });

      // Navigate based on user state
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen(hasActiveSession);
    } catch (e) {
      _showConnectionError();
    }
  }

  Future<bool> _checkAnonymousSession() async {
    // Simulate checking for existing anonymous session
    // In real implementation, this would check SharedPreferences or secure storage
    await Future.delayed(const Duration(milliseconds: 300));
    return false; // Simulate no active session for first-time users
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences from local storage
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<bool> _initializeWebSocket() async {
    // Simulate WebSocket connection initialization
    await Future.delayed(const Duration(milliseconds: 400));
    // Simulate 90% success rate
    return DateTime.now().millisecond % 10 != 0;
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached chat data
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _showConnectionError() {
    setState(() {
      _isInitializing = false;
      _showRetryButton = true;
      _loadingText = 'Erro de conexão. Tente novamente.';
    });

    // Auto-retry after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showRetryButton) {
        _retryInitialization();
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _showRetryButton = false;
      _isInitializing = true;
      _loadingText = 'Tentando reconectar...';
    });
    _initializeApp();
  }

  void _navigateToNextScreen(bool hasActiveSession) {
    // Restore system UI before navigation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (hasActiveSession) {
      // User has active session, go to recent chats
      Navigator.pushReplacementNamed(context, '/recent-chats-list');
    } else {
      // First-time user, go to nickname creation
      Navigator.pushReplacementNamed(context, '/nickname-creation-screen');
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoadingIndicator(),
                    SizedBox(height: 3.h),
                    _buildLoadingText(),
                    if (_showRetryButton) ...[
                      SizedBox(height: 3.h),
                      _buildRetryButton(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'chat_bubble_outline',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 12.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'Random\nChat',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return _isInitializing
        ? AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingAnimation.value * 2 * 3.14159,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: CustomPaint(
                    painter: _LoadingPainter(),
                  ),
                ),
              );
            },
          )
        : _showRetryButton
            ? CustomIconWidget(
                iconName: 'error_outline',
                color: Colors.white,
                size: 8.w,
              )
            : CustomIconWidget(
                iconName: 'check_circle_outline',
                color: Colors.white,
                size: 8.w,
              );
  }

  Widget _buildLoadingText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        _loadingText,
        textAlign: TextAlign.center,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton(
      onPressed: _retryInitialization,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.lightTheme.colorScheme.primary,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'Tentar Novamente',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Draw loading arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      3.14159, // Half circle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
