import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recommendations_screen.dart';

class ResultsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const ResultsScreen({super.key, this.onBack, this.onNext});

  static const _bg = Color(0xFFF9EFF2);
  static const _cardBg = Color(0xFFFBF0F3);
  static const _pink = Color(0xFF8B2252);
  static const _textDark = Color(0xFF1C1C1C);
  static const _textMid = Color(0xFF9B7C88);
  static const _borderColor = Color(0xFFEDD5DE);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────
            _AppBar(onBack: onBack, w: w, h: h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.055),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.008),

                    // ── Title ───────────────────────────────────
                    Center(
                      child: Text(
                        'Your Face Analysis',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: _s(w, 26),
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.028),

                    // ── Face Shape Card ──────────────────────────
                    _FaceShapeCard(w: w, h: h),

                    SizedBox(height: h * 0.022),

                    // ── Key Features Card ────────────────────────
                    _KeyFeaturesCard(w: w),

                    SizedBox(height: h * 0.022),

                    // ── Summary Card ─────────────────────────────
                    _SummaryCard(w: w),

                    SizedBox(height: h * 0.032),

                    // ── See Recommendations Button ───────────────
                    _PrimaryButton(
                      label: 'See Recommendations',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecommendationsScreen(),
                          ),
                        );
                      },
                      w: w,
                    ),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback? onBack;
  final double w, h;

  const _AppBar({this.onBack, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.014),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCB8FA8).withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1C1C1C),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Face Shape Card
// ─────────────────────────────────────────────────────────────
class _FaceShapeCard extends StatelessWidget {
  final double w, h;
  const _FaceShapeCard({required this.w, required this.h});

  static const _cardBg = Color(0xFFFBF0F3);
  static const _borderColor = Color(0xFFEDD5DE);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.055, vertical: h * 0.028),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Face Shape',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 13),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9B7C88),
                  ),
                ),
                SizedBox(height: h * 0.010),
                Text(
                  'Oval',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 36),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1C1C1C),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // Oval face illustration
          SizedBox(
            width: w * 0.26,
            height: w * 0.28,
            child: CustomPaint(painter: _OvalFaceIllustrationPainter()),
          ),
        ],
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Key Features Card
// ─────────────────────────────────────────────────────────────
class _KeyFeaturesCard extends StatelessWidget {
  final double w;
  const _KeyFeaturesCard({required this.w});

  static const _cardBg = Color(0xFFFBF0F3);
  static const _borderColor = Color(0xFFEDD5DE);

  static const _features = [
    'Balanced Forehead',
    'Slightly Rounded Jawline',
    'Medium Face Length',
  ];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.055, vertical: h * 0.026),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Features',
            style: GoogleFonts.playfairDisplay(
              fontSize: _s(w, 16),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1C1C),
            ),
          ),
          SizedBox(height: h * 0.018),
          ..._features.map((f) => _FeatureRow(label: f, w: w)),
        ],
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

class _FeatureRow extends StatelessWidget {
  final String label;
  final double w;
  const _FeatureRow({required this.label, required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.030),
      child: Row(
        children: [
          const Icon(Icons.check_rounded, color: Color(0xFF8B2252), size: 18),
          SizedBox(width: w * 0.028),
          Text(
            label,
            style: GoogleFonts.playfairDisplay(
              fontSize: _s(w, 14),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4A2030),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Summary Card
// ─────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final double w;
  const _SummaryCard({required this.w});

  static const _cardBg = Color(0xFFFBF0F3);
  static const _borderColor = Color(0xFFEDD5DE);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.055, vertical: h * 0.026),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor, width: 1.2),
      ),
      child: Text(
        'Great! Oval face shape suits a wide range of hairstyles.',
        style: GoogleFonts.playfairDisplay(
          fontSize: _s(w, 14.5),
          fontWeight: FontWeight.w400,
          color: const Color(0xFF4A2030),
          height: 1.65,
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Primary Button
// ─────────────────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double w;

  const _PrimaryButton({required this.label, required this.w, this.onTap});

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFF8B2252).withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 16),
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

// ─────────────────────────────────────────────────────────────
// Oval Face Illustration Painter
// Draws a minimalist line-art oval face: head, eyes, nose, lips
// ─────────────────────────────────────────────────────────────
class _OvalFaceIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final linePaint = Paint()
      ..color = const Color(0xFF8B2252)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.038
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ── Head oval ─────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromLTWH(w * 0.14, h * 0.04, w * 0.72, h * 0.76),
      linePaint,
    );

    // ── Left eye ──────────────────────────────────────────────
    final leftEyeRect = Rect.fromCenter(
      center: Offset(w * 0.36, h * 0.36),
      width: w * 0.18,
      height: h * 0.08,
    );
    canvas.drawArc(leftEyeRect, 3.14, 3.14, false, linePaint);

    // ── Right eye ─────────────────────────────────────────────
    final rightEyeRect = Rect.fromCenter(
      center: Offset(w * 0.64, h * 0.36),
      width: w * 0.18,
      height: h * 0.08,
    );
    canvas.drawArc(rightEyeRect, 3.14, 3.14, false, linePaint);

    // ── Nose (simple vertical line + base curve) ──────────────
    // Bridge line
    canvas.drawLine(
      Offset(w * 0.50, h * 0.40),
      Offset(w * 0.50, h * 0.55),
      linePaint,
    );
    // Nose base curve
    final nosePath = Path()
      ..moveTo(w * 0.38, h * 0.57)
      ..cubicTo(w * 0.42, h * 0.60, w * 0.58, h * 0.60, w * 0.62, h * 0.57);
    canvas.drawPath(nosePath, linePaint);

    // ── Lips ─────────────────────────────────────────────────
    // Upper lip
    final upperLip = Path()
      ..moveTo(w * 0.36, h * 0.66)
      ..cubicTo(w * 0.43, h * 0.63, w * 0.57, h * 0.63, w * 0.64, h * 0.66);
    canvas.drawPath(upperLip, linePaint);

    // Lower lip curve
    final lowerLip = Path()
      ..moveTo(w * 0.36, h * 0.66)
      ..cubicTo(w * 0.43, h * 0.72, w * 0.57, h * 0.72, w * 0.64, h * 0.66);
    canvas.drawPath(lowerLip, linePaint);

    // ── Neck ──────────────────────────────────────────────────
    canvas.drawLine(
      Offset(w * 0.40, h * 0.80),
      Offset(w * 0.40, h * 0.94),
      linePaint,
    );
    canvas.drawLine(
      Offset(w * 0.60, h * 0.80),
      Offset(w * 0.60, h * 0.94),
      linePaint,
    );
    // Collar line
    canvas.drawLine(
      Offset(w * 0.28, h * 0.94),
      Offset(w * 0.72, h * 0.94),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
