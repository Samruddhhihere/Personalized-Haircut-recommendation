import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding3.dart';

class Onboarding2Screen extends StatefulWidget {
  final VoidCallback? onNext;
  const Onboarding2Screen({super.key, this.onNext});

  @override
  State<Onboarding2Screen> createState() => _Onboarding2ScreenState();
}

class _Onboarding2ScreenState extends State<Onboarding2Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
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
              SizedBox(height: h * 0.052),

              // ── Title ─────────────────────────────────────────
              Text(
                'AI-Powered\nFace Analysis',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: _s(w, 30),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1C1C1C),
                  height: 1.22,
                ),
              ),

              SizedBox(height: h * 0.018),

              // ── Subtitle ──────────────────────────────────────
              Text(
                'We analyze your face shape\nand features',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: _s(w, 15),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9B7C88),
                  height: 1.6,
                ),
              ),

              SizedBox(height: h * 0.045),

              // ── Face analysis illustration ────────────────────
              Expanded(
                child: _FaceAnalysisWidget(pulse: _pulse, size: size),
              ),

              SizedBox(height: h * 0.028),

              // ── Bottom row ────────────────────────────────────
              _BottomRow(onNext: widget.onNext),

              SizedBox(height: h * 0.042),
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
// Face Analysis Illustration
// ─────────────────────────────────────────────────────────────
class _FaceAnalysisWidget extends StatelessWidget {
  final AnimationController pulse;
  final Size size;
  const _FaceAnalysisWidget({required this.pulse, required this.size});

  @override
  Widget build(BuildContext context) {
    final w = size.width;
    final frameW = w * 0.82;
    final frameH = frameW * 1.14;

    return SizedBox(
      width: frameW,
      height: frameH,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Arch / oval background card
          Positioned.fill(child: CustomPaint(painter: _ArchPainter())),

          // Portrait image
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: _ArchClipper(frameW: frameW, frameH: frameH),
              child: SizedBox(
                width: frameW,
                height: frameH,
                child: Image.asset(
                  'assets/images/onboarding2_portrait.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFFF0DDE4),
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 80,
                      color: const Color(0xFFCB8FA8).withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Face mesh overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _FaceMeshPainter(frameW: frameW, frameH: frameH),
            ),
          ),

          // Sparkle top-right (outside card)
          Positioned(
            top: -frameH * 0.01,
            right: -frameW * 0.05,
            child: AnimatedBuilder(
              animation: pulse,
              builder: (_, _) => Opacity(
                opacity: 0.55 + 0.45 * pulse.value,
                child: CustomPaint(
                  size: Size(frameW * 0.07, frameW * 0.07),
                  painter: _SparklePainter(color: const Color(0xFFBF6090)),
                ),
              ),
            ),
          ),

          // Sparkle mid-left (outside card)
          Positioned(
            top: frameH * 0.42,
            left: -frameW * 0.08,
            child: AnimatedBuilder(
              animation: pulse,
              builder: (_, _) => Opacity(
                opacity: 0.4 + 0.4 * (1 - pulse.value),
                child: CustomPaint(
                  size: Size(frameW * 0.045, frameW * 0.045),
                  painter: _SparklePainter(color: const Color(0xFFBF6090)),
                ),
              ),
            ),
          ),

          // Sparkle mid-right (outside card)
          Positioned(
            top: frameH * 0.44,
            right: -frameW * 0.01,
            child: AnimatedBuilder(
              animation: pulse,
              builder: (_, _) => Opacity(
                opacity: 0.3 + 0.4 * pulse.value,
                child: CustomPaint(
                  size: Size(frameW * 0.035, frameW * 0.035),
                  painter: _SparklePainter(color: const Color(0xFFBF6090)),
                ),
              ),
            ),
          ),

          // ── Floating icon chips ────────────────────────────
          // Top-left: face scan
          Positioned(
            top: frameH * 0.22,
            left: -frameW * 0.14,
            child: _IconChip(
              icon: Icons.face_retouching_natural_outlined,
              pulse: pulse,
              delay: 0.0,
            ),
          ),

          // Top-right: analytics
          Positioned(
            top: frameH * 0.22,
            right: -frameW * 0.14,
            child: _IconChip(
              icon: Icons.bar_chart_rounded,
              pulse: pulse,
              delay: 0.33,
            ),
          ),

          // Mid-left: person/hair
          Positioned(
            top: frameH * 0.50,
            left: -frameW * 0.14,
            child: _IconChip(
              icon: Icons.person_outline_rounded,
              pulse: pulse,
              delay: 0.66,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Arch background card
// ─────────────────────────────────────────────────────────────
class _ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..color = const Color(0xFFF5E0E8);

    final path = Path()
      ..moveTo(w * 0.08, h)
      ..lineTo(w * 0.08, h * 0.30)
      ..cubicTo(w * 0.08, h * 0.02, w * 0.92, h * 0.02, w * 0.92, h * 0.30)
      ..lineTo(w * 0.92, h)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
// Arch clipper for image
// ─────────────────────────────────────────────────────────────
class _ArchClipper extends CustomClipper<Path> {
  final double frameW, frameH;
  const _ArchClipper({required this.frameW, required this.frameH});

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.08, h)
      ..lineTo(w * 0.08, h * 0.30)
      ..cubicTo(w * 0.08, h * 0.02, w * 0.92, h * 0.02, w * 0.92, h * 0.30)
      ..lineTo(w * 0.92, h)
      ..close();
  }

  @override
  bool shouldReclip(_) => false;
}

// ─────────────────────────────────────────────────────────────
// Face mesh dots + lines overlay
// ─────────────────────────────────────────────────────────────
class _FaceMeshPainter extends CustomPainter {
  final double frameW, frameH;
  const _FaceMeshPainter({required this.frameW, required this.frameH});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final linePaint = Paint()
      ..color = const Color(0xFFCB8FA8).withValues(alpha: 0.55)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // Landmark points roughly mapped to face proportions
    final points = <Offset>[
      // Forehead top
      Offset(w * 0.50, h * 0.12),
      // Temple left/right
      Offset(w * 0.28, h * 0.22),
      Offset(w * 0.72, h * 0.22),
      // Eyes
      Offset(w * 0.34, h * 0.32),
      Offset(w * 0.50, h * 0.30),
      Offset(w * 0.66, h * 0.32),
      // Nose bridge / tip
      Offset(w * 0.50, h * 0.38),
      Offset(w * 0.50, h * 0.50),
      // Cheeks
      Offset(w * 0.25, h * 0.46),
      Offset(w * 0.75, h * 0.46),
      // Mouth corners + center
      Offset(w * 0.38, h * 0.60),
      Offset(w * 0.50, h * 0.58),
      Offset(w * 0.62, h * 0.60),
      // Chin
      Offset(w * 0.50, h * 0.72),
      // Jaw
      Offset(w * 0.30, h * 0.64),
      Offset(w * 0.70, h * 0.64),
    ];

    // Draw connecting lines (triangulation-style)
    final connections = [
      [0, 1],
      [0, 2],
      [0, 4],
      [1, 3],
      [1, 8],
      [2, 5],
      [2, 9],
      [3, 4],
      [4, 5],
      [4, 6],
      [6, 7],
      [7, 10],
      [7, 11],
      [7, 12],
      [8, 10],
      [8, 14],
      [9, 12],
      [9, 15],
      [10, 11],
      [11, 12],
      [10, 14],
      [12, 15],
      [14, 13],
      [15, 13],
    ];

    for (final c in connections) {
      canvas.drawLine(points[c[0]], points[c[1]], linePaint);
    }

    // Draw dots
    for (final pt in points) {
      canvas.drawCircle(pt, 2.4, dotPaint);
      canvas.drawCircle(
        pt,
        2.4,
        Paint()
          ..color = const Color(0xFFCB8FA8).withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
// Floating icon chip
// ─────────────────────────────────────────────────────────────
class _IconChip extends StatelessWidget {
  final IconData icon;
  final AnimationController pulse;
  final double delay;

  const _IconChip({
    required this.icon,
    required this.pulse,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, _) {
        final t = ((pulse.value + delay) % 1.0);
        final offset = math.sin(t * math.pi * 2) * 3.0;
        return Transform.translate(
          offset: Offset(0, offset),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCB8FA8).withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFFBF6090), size: 26),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sparkle painter
// ─────────────────────────────────────────────────────────────
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
// Bottom row: dots + FAB
// ─────────────────────────────────────────────────────────────
class _BottomRow extends StatelessWidget {
  final VoidCallback? onNext;
  const _BottomRow({this.onNext});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: List.generate(3, (i) {
            final active = i == 1;
            return Container(
              margin: const EdgeInsets.only(right: 8),
              width: active ? 10 : 9,
              height: active ? 10 : 9,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFFB76E8A)
                    : const Color(0xFFE8D2DA),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Onboarding3Screen(),
              ),
            );
          },
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFF8B2252),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x338B2252),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}
