import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollAnimator extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset offset;
  final double visibleFraction;

  const ScrollAnimator({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.offset = const Offset(0, 40),
    this.visibleFraction = 0.15,
  });

  @override
  State<ScrollAnimator> createState() => _ScrollAnimatorState();
}

class _ScrollAnimatorState extends State<ScrollAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scroll-anim-${widget.hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= widget.visibleFraction && !_isVisible) {
          _isVisible = true;
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
