import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingIcon extends StatefulWidget {
  final String imagePath;
  final double size;
  final Duration duration;
  final Offset startPosition;

  const FloatingIcon({
    Key? key,
    required this.imagePath,
    this.size = 60,
    this.duration = const Duration(seconds: 4),
    required this.startPosition,
  }) : super(key: key);

  @override
  State<FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<FloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _rotationAnimation;
  final math.Random _random = math.Random();
  late double _initialRotation;

  @override
  void initState() {
    super.initState();
    // Random initial rotation between -π and π (full 360 degrees)
    _initialRotation = (_random.nextDouble() * 2 * math.pi) - math.pi;
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimation();
    _controller.repeat(reverse: true);
  }

  void _setupAnimation() {
    // Increased movement range for faster/more noticeable motion
    final double dx = (_random.nextDouble() - 0.5) * 0.4;
    final double dy = (_random.nextDouble() - 0.5) * 0.4;

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx, dy),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Increased rotation amount for more dramatic spinning
    final double rotationAmount = (_random.nextDouble() - 0.5) * 1.5;
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: rotationAmount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.startPosition.dx,
      top: widget.startPosition.dy,
      child: SlideTransition(
        position: _animation,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _initialRotation + _rotationAnimation.value,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  widget.imagePath,
                  width: widget.size,
                  height: widget.size,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FloatingBackgroundIcons extends StatelessWidget {
  final String imagePath;

  const FloatingBackgroundIcons({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        FloatingIcon(
          imagePath: imagePath,
          size: 150,
          duration: const Duration(seconds: 2), // Faster: was 4
          startPosition: Offset(size.width * 0.1, size.height * 0.15),
        ),
        FloatingIcon(
          imagePath: imagePath,
          size: 140,
          duration: const Duration(seconds: 2, milliseconds: 500), // Faster: was 5
          startPosition: Offset(size.width * 0.75, size.height * 0.25),
        ),
        FloatingIcon(
          imagePath: imagePath,
          size: 190,
          duration: const Duration(seconds: 3), // Faster: was 6
          startPosition: Offset(size.width * 0.15, size.height * 0.65),
        ),
        FloatingIcon(
          imagePath: imagePath,
          size: 150,
          duration: const Duration(seconds: 2, milliseconds: 500), // Faster: was 5
          startPosition: Offset(size.width * 0.8, size.height * 0.75),
        ),
      ],
    );
  }
}