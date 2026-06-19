import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class Onboarding3Screen extends StatefulWidget {
  final VoidCallback? onNext;
  const Onboarding3Screen({super.key, this.onNext});

  @override
  State<Onboarding3Screen> createState() => _Onboarding3ScreenState();
}

class _Onboarding3ScreenState extends State<Onboarding3Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9EFF2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.048),

              // Title
              Text(
                'Personalized\nRecommendations',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: _s(w, 30),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1C1C1C),
                  height: 1.22,
                ),
              ),

              SizedBox(height: h * 0.018),

              // Subtitle
              Text(
                'Save, compare & choose\nyour perfect style',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: _s(w, 15),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9B7C88),
                  height: 1.6,
                ),
              ),

              SizedBox(height: h * 0.032),

              // Illustration
              Expanded(
                child: _RecommendationIllustration(pulse: _pulse, size: size),
              ),

              SizedBox(height: h * 0.022),

              // Dots
              _DotIndicator(),

              SizedBox(height: h * 0.026),

              // Get Started button
              _GetStartedButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),

              SizedBox(height: h * 0.038),
            ],
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Main illustration: central portrait + 3 recommendation cards
// ─────────────────────────────────────────────────────────────
class _RecommendationIllustration extends StatelessWidget {
  final AnimationController pulse;
  final Size size;
  const _RecommendationIllustration({required this.pulse, required this.size});

  @override
  Widget build(BuildContext context) {
    final w = size.width;
    final areaW = w * 0.88;
    final areaH = areaW * 1.12;

    return SizedBox(
      width: areaW,
      height: areaH,
      child: Image.asset(
        'assets/images/onboarding3_potrait.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Central large portrait fading at top
// ─────────────────────────────────────────────────────────────
class _CentralPortrait extends StatelessWidget {
  final double areaW, areaH;
  const _CentralPortrait({required this.areaW, required this.areaH});

  @override
  Widget build(BuildContext context) {
    final pw = areaW * 0.60;
    final ph = areaH * 0.60;

    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.white],
        stops: [0.0, 0.28],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        width: pw,
        height: ph,
        child: Image.asset(
          'assets/images/onboarding_portrait.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (_, _, _) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0DDE4),
              borderRadius: BorderRadius.circular(pw * 0.5),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 64,
              color: const Color(0xFFCB8FA8).withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Individual hair style recommendation card
// ─────────────────────────────────────────────────────────────
class _HairCard extends StatelessWidget {
  final String label;
  final String match;
  final String imagePath;
  final double width;

  const _HairCard({
    required this.label,
    required this.match,
    required this.imagePath,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final imgH = width * 1.05;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCB8FA8).withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(width * 0.10),
                ),
                child: SizedBox(
                  width: width,
                  height: imgH,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFF5E0E8),
                      child: Icon(
                        Icons.face_retouching_natural_outlined,
                        size: 36,
                        color: const Color(0xFFCB8FA8).withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
              // Heart badge
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B2252),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),

          // Labels
          Padding(
            padding: EdgeInsets.fromLTRB(
              width * 0.10,
              width * 0.07,
              width * 0.06,
              width * 0.09,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: width * 0.115,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C1C1C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  match,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: width * 0.095,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9B5070),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Soft blob / oval background shape
// ─────────────────────────────────────────────────────────────
class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = const Color(0xFFF2D5DF).withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(w * 0.50, h * 0.48),
          width: w * 0.80,
          height: h * 0.70,
        ),
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
// Dashed arc arrows connecting cards to center
// ─────────────────────────────────────────────────────────────
class _ArrowArcPainter extends CustomPainter {
  final double areaW, areaH;
  const _ArrowArcPainter({required this.areaW, required this.areaH});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = const Color(0xFFCB8FA8).withValues(alpha: 0.50)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Top card → center: gentle curve from top-center downward
    _drawDashedPath(
      canvas,
      _arcPath(
        Offset(w * 0.50, h * 0.22),
        Offset(w * 0.50, h * 0.38),
        Offset(w * 0.52, h * 0.30),
      ),
      paint,
    );

    // Left card → center
    _drawDashedPath(
      canvas,
      _arcPath(
        Offset(w * 0.26, h * 0.44),
        Offset(w * 0.40, h * 0.50),
        Offset(w * 0.30, h * 0.50),
      ),
      paint,
    );

    // Right card → center
    _drawDashedPath(
      canvas,
      _arcPath(
        Offset(w * 0.74, h * 0.44),
        Offset(w * 0.60, h * 0.50),
        Offset(w * 0.70, h * 0.50),
      ),
      paint,
    );
  }

  Path _arcPath(Offset start, Offset end, Offset cp) {
    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(cp.dx, cp.dy, end.dx, end.dy);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashLen = 5.0;
    const gapLen = 4.0;
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double dist = 0;
      bool draw = true;
      while (dist < metric.length) {
        final len = draw ? dashLen : gapLen;
        if (draw) {
          canvas.drawPath(
            metric.extractPath(dist, math.min(dist + len, metric.length)),
            paint,
          );
        }
        dist += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
// Sparkle widget
// ─────────────────────────────────────────────────────────────
class _Sparkle extends StatelessWidget {
  final AnimationController pulse;
  final double delay;
  final double? left, right, top, bottom;
  final double sz;

  const _Sparkle({
    required this.pulse,
    required this.delay,
    required this.sz,
  }) : left = null, right = null, top = null, bottom = null;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: pulse,
        builder: (_, _) {
          final t = (pulse.value + delay) % 1.0;
          final opacity = 0.3 + 0.5 * math.sin(t * math.pi);
          return Opacity(
            opacity: opacity,
            child: CustomPaint(
              size: Size(sz, sz),
              painter: _SparklePainter(color: const Color(0xFFBF6090)),
            ),
          );
        },
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final Color color;
  const _SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) - math.pi / 2;
      final ox = cx + r * math.cos(angle);
      final oy = cy + r * math.sin(angle);
      final ir = r * 0.28;
      final a1 = angle + math.pi / 4;
      final a2 = angle - math.pi / 4;
      final ix1 = cx + ir * math.cos(a1);
      final iy1 = cy + ir * math.sin(a1);
      final ix2 = cx + ir * math.cos(a2);
      final iy2 = cy + ir * math.sin(a2);
      if (i == 0) path.moveTo(ix2, iy2);
      path.lineTo(ox, oy);
      path.lineTo(ix1, iy1);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
// Page dot indicator — 3rd dot active
// ─────────────────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == 2;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 10 : 9,
          height: active ? 10 : 9,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFB76E8A) : const Color(0xFFE8D2DA),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Get Started button
// ─────────────────────────────────────────────────────────────
class _GetStartedButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _GetStartedButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF8B2252),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B2252).withValues(alpha: 0.30),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'Get Started',
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 17),
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}
