
import 'dart:async';

import 'package:divineesoft_gym_pro_app/features/webview/screens/webview_screen.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _glowController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _entranceController.forward();
    _glowController.repeat(reverse: true);

    _navigationTimer = Timer(
      const Duration(milliseconds: 2400),
      _openDashboard,
    );
  }

  void _openDashboard() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) {
          return const WebViewScreen();
        },
        transitionDuration: const Duration(milliseconds: 650),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entranceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: Center(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF101D36),
                    Color(0xFF0B0E14),
                    Color(0xFF05080F),
                  ],
                ),
              ),
            ),
        
            // Top ambient glow
            Positioned(
              top: -180,
              left: -100,
              child: _glowCircle(
                size: 380,
                color: const Color(0xFF126BFF),
              ),
            ),
        
            // Bottom ambient glow
            Positioned(
              bottom: -190,
              right: -120,
              child: _glowCircle(
                size: 390,
                color: const Color(0xFF087FBA),
              ),
            ),
        
            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
        
                  // Animated logo
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      final glow = 0.25 +
                          (_glowController.value * 0.35);
        
                      return Transform.scale(
                        scale: 0.97 +
                            (_glowController.value * 0.03),
                        child: Container(
                          width: 180,
                          height: 180,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF111C30),
                            border: Border.all(
                              color: const Color(0xFF21D4F5)
                                  .withOpacity(0.55),
                              width: 1.3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF126BFF)
                                    .withOpacity(glow),
                                blurRadius: 65,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Image.asset(
                            'assets/app_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 36),
        
                  // Brand name
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'GYM ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'PRO',
                                    style: TextStyle(
                                      color: Color(0xFF21D4F5),
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            const Text(
                              'YOUR FITNESS MANAGEMENT PLATFORM',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF9BAFCB),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        
                  const Spacer(flex: 2),
        
                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 115,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20),
                            child: const LinearProgressIndicator(
                              minHeight: 3,
                              backgroundColor:
                                  Color(0xFF25334B),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                Color(0xFF21D4F5),
                              ),
                            ),
                          ),
                        ),
        
                        const SizedBox(height: 18),
        
                        const Text(
                          'POWERING YOUR FITNESS BUSINESS',
                          style: TextStyle(
                            color: Color(0xFF71839E),
                            fontSize: 9,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 45),
        
                  // Company branding
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Container(
                          width: 38,
                          height: 1,
                          color: const Color(0xFF21D4F5)
                              .withOpacity(0.65),
                        ),
        
                        const SizedBox(height: 14),
        
                        const Text(
                          'DIVINEESOFT TECHNOLOGIES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
        
                        const SizedBox(height: 5),
        
                        const Text(
                          'PVT. LTD.',
                          style: TextStyle(
                            color: Color(0xFF71839E),
                            fontSize: 9,
                            letterSpacing: 2.5,
                          ),
                        ),
        
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.19),
              color.withOpacity(0.07),
              color.withOpacity(0),
            ],
          ),
        ),
      ),
    );
  }
}
