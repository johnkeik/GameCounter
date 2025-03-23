import 'package:flutter/material.dart';

class AnimationUtils {
  /// Creates a bounce-in animation for widgets
  static Widget bounceIn({
    required Widget child,
    required bool animate,
    Duration duration = const Duration(milliseconds: 400),
    double offset = 50.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: animate ? 0.0 : 1.0, end: 1.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, offset * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
  
  /// Creates a pulsing animation for widgets
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    double minScale = 0.97,
    double maxScale = 1.03,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: minScale, end: maxScale),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
      onEnd: () {
        // Reverse the animation when it completes
        minScale = minScale == 0.97 ? 1.03 : 0.97;
        maxScale = maxScale == 1.03 ? 0.97 : 1.03;
      },
    );
  }
  
  /// Creates a slide-and-fade animation for lists
  static Widget slideAndFade({
    required Widget child,
    required int index,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutQuad,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: duration.inMilliseconds + (index * 50)),
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
