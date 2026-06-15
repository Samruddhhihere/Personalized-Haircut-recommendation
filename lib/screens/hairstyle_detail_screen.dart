import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'try_on_screen.dart';

class HairstyleDetailScreen extends StatefulWidget {
  final String styleName;
  final String matchPercent;
  final String imagePath;
  final VoidCallback? onBack;
  final VoidCallback? onTryPreview;
  final VoidCallback? onSave;

  const HairstyleDetailScreen({
    super.key,
    this.styleName = 'Layer Cut',
    this.matchPercent = '94% Match',
    this.imagePath = 'assets/images/hair_layer_cut.png',
    this.onBack,
    this.onTryPreview,
    this.onSave,
  });

  @override
  State<HairstyleDetailScreen> createState() => _HairstyleDetailScreenState();
}

class _HairstyleDetailScreenState extends State<HairstyleDetailScreen> {
  bool _saved = false;

  static const _bg = Color(0xFFF9EFF2);
  static const _cardBg = Color(0xFFFBF0F3);
  static const _pink = Color(0xFF8B2252);
  static const _textDark = Color(0xFF1C1C1C);
  static const _textMid = Color(0xFF9B7C88);
  static const _divider = Color(0xFFEDD5DE);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Screen title ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.055,
                vertical: h * 0.014,
              ),
              child: Center(
                child: Text(
                  '11. Hairstyle Detail',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 18),
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.006),

                    // ── Main card ─────────────────────────────────
                    _MainCard(
                      imagePath: widget.imagePath,
                      styleName: widget.styleName,
                      matchPercent: widget.matchPercent,
                      saved: _saved,
                      onBack:
                          widget.onBack ?? () => Navigator.maybePop(context),
                      onToggleSave: () => setState(() => _saved = !_saved),
                      onTryPreview: widget.onTryPreview,
                      onSave: widget.onSave,
                      w: w,
                      h: h,
                    ),

                    SizedBox(height: h * 0.02),
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
// Main Card — image + all detail content inside one card
// ─────────────────────────────────────────────────────────────
class _MainCard extends StatelessWidget {
  final String imagePath;
  final String styleName;
  final String matchPercent;
  final bool saved;
  final VoidCallback onBack;
  final VoidCallback onToggleSave;
  final VoidCallback? onTryPreview;
  final VoidCallback? onSave;
  final double w, h;

  const _MainCard({
    required this.imagePath,
    required this.styleName,
    required this.matchPercent,
    required this.saved,
    required this.onBack,
    required this.onToggleSave,
    required this.onTryPreview,
    required this.onSave,
    required this.w,
    required this.h,
  });

  static const _cardBg = Color(0xFFFBF0F3);
  static const _pink = Color(0xFF8B2252);
  static const _textDark = Color(0xFF1C1C1C);
  static const _textMid = Color(0xFF9B7C88);
  static const _divider = Color(0xFFEDD5DE);

  @override
  Widget build(BuildContext context) {
    final imgH = h * 0.38;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCB8FA8).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image section ──────────────────────────────────────
          SizedBox(
            height: imgH,
            width: double.infinity,
            child: Stack(
              children: [
                // Portrait image
                Positioned.fill(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFF0DDE4),
                      child: const Icon(
                        Icons.face_retouching_natural_outlined,
                        size: 64,
                        color: Color(0xFFCB8FA8),
                      ),
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: h * 0.018,
                  left: w * 0.04,
                  child: GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFF1C1C1C),
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Heart button
                Positioned(
                  top: h * 0.018,
                  right: w * 0.04,
                  child: GestureDetector(
                    onTap: onToggleSave,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: saved ? _pink : Colors.white.withValues(alpha: 0.88),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        saved ? Icons.favorite : Icons.favorite_border_rounded,
                        color: saved ? Colors.white : _pink,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Detail content ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.055,
              vertical: h * 0.022,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + match row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      styleName,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: _s(w, 22),
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      matchPercent,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: _s(w, 15),
                        fontWeight: FontWeight.w700,
                        color: _pink,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.018),

                // Why it suits you
                Text(
                  'Why it suits you',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 13.5),
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: h * 0.006),
                Text(
                  'Balances your face proportions and adds volume around cheeks.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 13),
                    fontWeight: FontWeight.w400,
                    color: _textDark.withValues(alpha: 0.75),
                    height: 1.55,
                  ),
                ),

                SizedBox(height: h * 0.022),

                // Divider
                Divider(color: _divider, thickness: 1, height: 1),

                SizedBox(height: h * 0.020),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _StatItem(label: 'Maintenance', value: 'Medium'),
                    _StatItem(label: 'Styling Time', value: '10 min'),
                    _StatItem(label: 'Length', value: 'Medium'),
                  ],
                ),

                SizedBox(height: h * 0.026),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      flex: 55,
                      child: _FilledButton(
                        label: 'Try Preview',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TryOnScreen(),
                            ),
                          );
                        },
                        w: w,
                      ),
                    ),
                    SizedBox(width: w * 0.035),
                    Expanded(
                      flex: 45,
                      child: _OutlineButton(label: 'Save', onTap: onSave, w: w),
                    ),
                  ],
                ),
              ],
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
// Stat Item
// ─────────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 11.5),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9B7C88),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 14),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1C1C1C),
          ),
        ),
      ],
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Filled Button — Try Preview
// ─────────────────────────────────────────────────────────────
class _FilledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double w;

  const _FilledButton({required this.label, required this.w, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF8B2252),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B2252).withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 15),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Outline Button — Save
// ─────────────────────────────────────────────────────────────
class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double w;

  const _OutlineButton({required this.label, required this.w, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFD8B4C2), width: 1.4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 15),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1C1C1C),
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}
