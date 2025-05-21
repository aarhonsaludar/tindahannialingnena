import 'package:flutter/material.dart';

/// Utility class providing custom page transitions and animations
class Transitions {
  /// Slide and fade transition
  static PageRouteBuilder<T> slideTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset beginOffset = const Offset(1.0, 0.0),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
  
  /// Fade transition
  static PageRouteBuilder<T> fadeTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        );
      },
    );
  }
  
  /// Scale and fade transition
  static PageRouteBuilder<T> scaleTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Alignment alignment = Alignment.center,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          alignment: alignment,
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
  
  /// Custom animated button that scales and changes opacity on tap
  static Widget animatedButton({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = const Duration(milliseconds: 150),
    double scaleChange = 0.95,
    double opacityChange = 0.9,
  }) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween<double>(begin: 1.0, end: 1.0),
      builder: (context, double value, child) {
        return GestureDetector(
          onTapDown: (_) => onPressed(),
          child: Transform.scale(
            scale: value,
            child: Opacity(opacity: value, child: child),
          ),
        );
      },
      child: child,
    );
  }
}
