import 'package:flutter/material.dart';

class BouncingSushiIcon extends StatefulWidget {
  final Widget child;
  final Duration interval;
  final bool enabled;

  const BouncingSushiIcon({
    super.key,
    required this.child,
    this.interval = const Duration(seconds: 2),
    this.enabled = true,
  });

  @override
  State<BouncingSushiIcon> createState() => _BouncingSushiIconState();
}

class _BouncingSushiIconState extends State<BouncingSushiIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.12,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.12,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _loop();
  }

  Future<void> _loop() async {
    while (mounted) {
      await Future.delayed(widget.interval);
      if (!mounted || !widget.enabled) continue;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
