import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _taglineAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _taglineOpacityAnimation;
  bool _isLoading = true;
  bool _showContinueButton = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _taglineAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _taglineOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startSplashSequence() async {
    // Start logo animation
    _logoAnimationController.forward();

    // Wait for logo animation to complete, then start tagline
    await Future.delayed(const Duration(milliseconds: 800));
    _taglineAnimationController.forward();

    // Simulate initialization tasks
    await _performInitializationTasks();

    // Show continue button after initialization
    if (mounted) {
      setState(() {
        _isLoading = false;
        _showContinueButton = true;
      });
    }
  }

  Future<void> _performInitializationTasks() async {
    // Simulate checking authentication status
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate fetching emergency contact data
    await Future.delayed(const Duration(milliseconds: 400));

    // Simulate preparing cached hospital information
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _navigateToNextScreen() {
    // For demo purposes, navigate to login screen
    // In real implementation, this would check authentication status
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _handleEmergencyAccess() {
    // Emergency bypass - go directly to emergency hospital finder
    Navigator.pushReplacementNamed(context, '/emergency-hospital-finder');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _taglineAnimationController.dispose();
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with pulse animation
                    AnimatedBuilder(
                      animation: _logoScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'local_hospital',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 12.w,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 3.h),

                    // App name
                    Text(
                      'CareLink',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Tagline with fade animation
                    AnimatedBuilder(
                      animation: _taglineOpacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _taglineOpacityAnimation.value,
                          child: Text(
                            'Your Health, Our Priority',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 6.h),

                    // Loading indicator or continue button
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _isLoading
                          ? Column(
                              key: const ValueKey('loading'),
                              children: [
                                SizedBox(
                                  width: 8.w,
                                  height: 8.w,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withValues(alpha: 0.8),
                                    ),
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Initializing healthcare services...',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            )
                          : _showContinueButton
                              ? ElevatedButton(
                                  key: const ValueKey('continue'),
                                  onPressed: _navigateToNextScreen,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Continue to App',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      CustomIconWidget(
                                        iconName: 'arrow_forward',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 5.w,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // Emergency button (bottom-right)
              Positioned(
                bottom: 4.h,
                right: 4.w,
                child: FloatingActionButton.extended(
                  onPressed: _handleEmergencyAccess,
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  icon: CustomIconWidget(
                    iconName: 'emergency',
                    color: Colors.white,
                    size: 6.w,
                  ),
                  label: Text(
                    'Emergency',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Version info (bottom-left)
              Positioned(
                bottom: 2.h,
                left: 4.w,
                child: Text(
                  'v1.0.0',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
