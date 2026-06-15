import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding1.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
 
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
 
    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
 
    _slideUp = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
 
    _controller.forward();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
       context,
       MaterialPageRoute(
        builder: (context) => const Onboarding1Screen(),
      ),
    );
  });
}
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
 
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFF2),
      body: Stack(
        children: [
          // Soft pink wave background at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.35,
              child: CustomPaint(
                painter: _WavePainter(),
                size: Size(size.width, size.height * 0.35),
              ),
            ),
          ),
 
          // Main content
          SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeIn,
                  child: Transform.translate(
                    offset: Offset(0, _slideUp.value),
                    child: child,
                  ),
                );
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
 
                    // Logo mark
                    SizedBox(
                      width: size.width * 0.38,
                      height: size.width * 0.38,
                      child: CustomPaint(
                        painter: _LogoPainter(),
                      ),
                    ),
 
                    SizedBox(height: size.height * 0.045),
 
                    // App name
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'HairVerse ',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: _responsiveFontSize(context, 36),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF8B2252),
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'AI',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: _responsiveFontSize(context, 36),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFFBF6090),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
 
                    SizedBox(height: size.height * 0.022),
 
                    // Tagline
                    Text(
                      'Find your perfect look',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: _responsiveFontSize(context, 17),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: const Color(0xFF9B5070),
                        letterSpacing: 0.3,
                      ),
                    ),
 
                    const Spacer(flex: 3),
 
                    // Dot indicator
                    _DotIndicator(),
 
                    SizedBox(height: size.height * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  double _responsiveFontSize(BuildContext context, double base) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / 390.0; // design base width
    return (base * scale).clamp(base * 0.8, base * 1.3);
  }
}
 
// ──────────────────────────────────────────────────────────────
// Logo Painter — replicates the stylised "H" with flowing hair
// strands and a sparkle star
// ──────────────────────────────────────────────────────────────
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
 
    // --- Deep rose fill for the H letterform ---
    final hPaint = Paint()
      ..color = const Color(0xFF8B2252)
      ..style = PaintingStyle.fill;
 
    // Left pillar of H
    final leftPillar = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.10, w * 0.18, h * 0.68),
      const Radius.circular(4),
    );
    canvas.drawRRect(leftPillar, hPaint);
 
    // Right pillar of H (narrower top to leave room for strand)
    final rightPillarPath = Path()
      ..moveTo(w * 0.74, h * 0.10)
      ..lineTo(w * 0.92, h * 0.10)
      ..lineTo(w * 0.92, h * 0.78)
      ..lineTo(w * 0.74, h * 0.78)
      ..close();
    canvas.drawPath(rightPillarPath, hPaint);
 
    // Cross bar of H
    final crossBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.40, w * 0.84, h * 0.15),
      const Radius.circular(3),
    );
    canvas.drawRRect(crossBar, hPaint);
 
    // --- Flowing hair strands (gradient pink curves on right pillar) ---
    _drawHairStrands(canvas, size);
 
    // --- Sparkle star at top-right ---
    _drawSparkle(canvas, size, Offset(w * 0.88, h * 0.04));
  }
 
  void _drawHairStrands(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
 
    // Three layered flowing curves emanating from right pillar top
    final gradients = [
      [const Color(0xFFD4789A), const Color(0xFFF0B8CC)],   // front (darkest)
      [const Color(0xFFE091B0), const Color(0xFFF5C8D8)],   // mid
      [const Color(0xFFF0B0C8), const Color(0xFFFDE0EB)],   // back (lightest)
    ];
 
    for (int i = 0; i < 3; i++) {
      final paint = Paint()
        ..shader = LinearGradient(
          colors: gradients[i],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ).createShader(Rect.fromLTWH(w * 0.45, 0, w * 0.55, h))
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * (0.07 - i * 0.015)
        ..strokeCap = StrokeCap.round;
 
      final path = Path();
      // Each strand curves outward from top-right of H and sweeps down-left
      final startX = w * (0.83 - i * 0.04);
      final startY = h * (0.08 + i * 0.04);
      path.moveTo(startX, startY);
      path.cubicTo(
        w * (0.98 - i * 0.02), h * (0.22 + i * 0.05),   // cp1
        w * (0.80 - i * 0.06), h * (0.60 + i * 0.04),   // cp2
        w * (0.55 - i * 0.04), h * (0.85 + i * 0.03),   // end — sweeps toward bottom-left
      );
      canvas.drawPath(path, paint);
    }
  }
 
  void _drawSparkle(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFFBF6090)
      ..style = PaintingStyle.fill;
 
    final r = size.width * 0.04;
 
    // 4-pointed star
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) - math.pi / 2;
      final outerX = center.dx + r * math.cos(angle);
      final outerY = center.dy + r * math.sin(angle);
      final innerAngle1 = angle + math.pi / 4;
      final innerAngle2 = angle - math.pi / 4;
      final ir = r * 0.28;
      final in1x = center.dx + ir * math.cos(innerAngle1);
      final in1y = center.dy + ir * math.sin(innerAngle1);
      final in2x = center.dx + ir * math.cos(innerAngle2);
      final in2y = center.dy + ir * math.sin(innerAngle2);
 
      if (i == 0) {
        path.moveTo(in2x, in2y);
      }
      path.lineTo(outerX, outerY);
      path.lineTo(in1x, in1y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
 
// ──────────────────────────────────────────────────────────────
// Wave Painter — three layered soft pink waves at the bottom
// ──────────────────────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
 
    final waves = [
      // back wave (lightest, tallest)
      _WaveConfig(
        color: const Color(0xFFF2D3DF),
        heightFraction: 0.55,
        cp1xFrac: 0.25,
        cp1yFrac: 0.05,
        cp2xFrac: 0.75,
        cp2yFrac: 0.85,
      ),
      // mid wave
      _WaveConfig(
        color: const Color(0xFFE8B8CB),
        heightFraction: 0.72,
        cp1xFrac: 0.30,
        cp1yFrac: 0.10,
        cp2xFrac: 0.70,
        cp2yFrac: 0.78,
      ),
      // front wave (darkest, lowest)
      _WaveConfig(
        color: const Color(0xFFDFA0BA),
        heightFraction: 0.88,
        cp1xFrac: 0.28,
        cp1yFrac: 0.20,
        cp2xFrac: 0.72,
        cp2yFrac: 0.68,
      ),
    ];
 
    for (final wave in waves) {
      final paint = Paint()
        ..color = wave.color
        ..style = PaintingStyle.fill;
 
      final path = Path()
        ..moveTo(0, h * wave.heightFraction)
        ..cubicTo(
          w * wave.cp1xFrac, h * wave.cp1yFrac,
          w * wave.cp2xFrac, h * wave.cp2yFrac,
          w, h * wave.heightFraction * 0.85,
        )
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close();
 
      canvas.drawPath(path, paint);
    }
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
 
class _WaveConfig {
  final Color color;
  final double heightFraction;
  final double cp1xFrac, cp1yFrac, cp2xFrac, cp2yFrac;
  const _WaveConfig({
    required this.color,
    required this.heightFraction,
    required this.cp1xFrac,
    required this.cp1yFrac,
    required this.cp2xFrac,
    required this.cp2yFrac,
  });
}
 
// ──────────────────────────────────────────────────────────────
// Three-dot page indicator
// ──────────────────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: const Color(0xFFBF6090).withValues(alpha: i == 1 ? 1.0 : 0.45),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
 