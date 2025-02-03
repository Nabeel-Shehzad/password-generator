import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final int numberOfParticles;
  final Color particleColor;

  const ParticleBackground({
    super.key,
    this.numberOfParticles = 50,
    this.particleColor = Colors.white,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        _updateParticles();
      });
    _controller.repeat();
  }

  void _initializeParticles() {
    final random = Random();
    particles = List.generate(
      widget.numberOfParticles,
      (index) => Particle(
        position: Offset(
          random.nextDouble() * 400,
          random.nextDouble() * 800,
        ),
        speed: Offset(
          random.nextDouble() * 2 - 1,
          random.nextDouble() * 2 - 1,
        ),
        radius: random.nextDouble() * 3 + 1,
      ),
    );
  }

  void _updateParticles() {
    for (var particle in particles) {
      particle.position += particle.speed;
      
      // Wrap particles around the screen
      if (particle.position.dx < 0) {
        particle.position = Offset(400, particle.position.dy);
      } else if (particle.position.dx > 400) {
        particle.position = Offset(0, particle.position.dy);
      }
      
      if (particle.position.dy < 0) {
        particle.position = Offset(particle.position.dx, 800);
      } else if (particle.position.dy > 800) {
        particle.position = Offset(particle.position.dx, 0);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(
        particles: particles,
        color: widget.particleColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class Particle {
  Offset position;
  Offset speed;
  final double radius;

  Particle({
    required this.position,
    required this.speed,
    required this.radius,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      canvas.drawCircle(particle.position, particle.radius, paint);
      
      // Draw connections between nearby particles
      for (var otherParticle in particles) {
        if (particle != otherParticle) {
          final distance = (particle.position - otherParticle.position).distance;
          if (distance < 100) {
            canvas.drawLine(
              particle.position,
              otherParticle.position,
              paint..strokeWidth = 0.5,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
