import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisScreen extends StatefulWidget {
  /// Called automatically when analysis reaches 100 % — navigate forward here.
  final VoidCallback? onComplete;
  final VoidCallback? onBack;

  const AnalysisScreen({
    super.key,
    this.onComplete,
    this.onBack,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  // Steps: label, completes at this progress fraction
  static const _steps = [
    _AnalysisStep(label: 'Detecting face shape', completesAt: 0.40),
    _AnalysisStep(label: 'Analyzing features', completesAt: 0.75),
    _AnalysisStep(label: 'Preparing recommendations', completesAt: 1.00),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _progressAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) widget.onComplete?.call();
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        child: Column(
          children: [
            // Back button row
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04, vertical: h * 0.014),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack ?? () => Navigator.maybePop(context),
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
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: h * 0.01),

                    // Title
                    Text(
                      'Analyzing Your Face',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: _s(w, 28),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1C1C1C),
                        height: 1.2,
                      ),
                    ),

                    SizedBox(height: h * 0.014),

                    // Subtitle
                    Text(
                      'Please wait while our AI\nanalyzes your features',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: _s(w, 14.5),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9B7C88),
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: h * 0.055),

                    // Animated progress ring
                    AnimatedBuilder(
                      animation: _progressAnim,
                      builder: (context, _) {
                        final progress = _progressAnim.value;
                        final percent = (progress * 100).round();
                        return _ProgressRing(
                          progress: progress,
                          percent: percent,
                          size: w * 0.52,
                        );
                      },
                    ),

                    SizedBox(height: h * 0.06),

                    // Step checklist
                    AnimatedBuilder(
                      animation: _progressAnim,
                      builder: (context, _) {
                        return Column(
                          children: _steps.map((step) {
                            final done =
                                _progressAnim.value >= step.completesAt;
                            final active =
                                _progressAnim.value < step.completesAt &&
                                    (step == _steps.first ||
                                        _progressAnim.value >=
                                            _steps[_steps.indexOf(step) - 1]
                                                .completesAt);
                            return _StepRow(
                              label: step.label,
                              done: done,
                              active: active,
                              w: w,
                            );
                          }).toList(),
                        );
                      },
                    ),
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
// Progress Ring
// ─────────────────────────────────────────────────────────────
class _ProgressRing extends StatelessWidget {
  final double progress;
  final int percent;
  final double size;

  const _ProgressRing({
    required this.progress,
    required this.percent,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Text(
            '$percent%',
            style: GoogleFonts.playfairDisplay(
              fontSize: size * 0.22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C1F38),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final strokeW = size.width * 0.095;
    final radius = (size.width - strokeW) / 2;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    // Track (background ring)
    final trackPaint = Paint()
      ..color = const Color(0xFFEDD5DE)
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    // Progress arc with gradient
    final progressPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          Color(0xFFE8A0B8),
          Color(0xFF8B2252),
          Color(0xFFD4789A),
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(rect)
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Dot at the tip of the progress arc
    if (progress > 0.01) {
      final angle = -math.pi / 2 + 2 * math.pi * progress;
      final dotX = cx + radius * math.cos(angle);
      final dotY = cy + radius * math.sin(angle);
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), strokeW * 0.38, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress;
}

// ─────────────────────────────────────────────────────────────
// Step Row
// ─────────────────────────────────────────────────────────────
class _StepRow extends StatelessWidget {
  final String label;
  final bool done;
  final bool active;
  final double w;

  const _StepRow({
    required this.label,
    required this.done,
    required this.active,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.042),
      child: Row(
        children: [
          // Icon
          _StepIcon(done: done, active: active),

          SizedBox(width: w * 0.035),

          // Label
          Text(
            label,
            style: GoogleFonts.playfairDisplay(
              fontSize: _s(w, 15),
              fontWeight: done ? FontWeight.w600 : FontWeight.w400,
              color: done
                  ? const Color(0xFF1C1C1C)
                  : const Color(0xFF9B7C88),
            ),
          ),
        ],
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

class _StepIcon extends StatelessWidget {
  final bool done;
  final bool active;

  const _StepIcon({required this.done, required this.active});

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Color(0xFFF5E0E8),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF8B2252),
          size: 26,
        ),
      );
    }

    // Not done — outlined circle
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFCB8FA8),
          width: 1.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Data model for a step
// ─────────────────────────────────────────────────────────────
class _AnalysisStep {
  final String label;

  /// The progress fraction [0,1] at which this step is considered complete.
  final double completesAt;

  const _AnalysisStep({required this.label, required this.completesAt});
}