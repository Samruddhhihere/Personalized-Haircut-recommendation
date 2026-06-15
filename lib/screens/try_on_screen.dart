import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'saved_screen.dart';

// ─────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────
class _StyleOption {
  final String name;
  final String thumbnailPath;
  final String beforeImagePath;
  final String afterImagePath;

  const _StyleOption({
    required this.name,
    required this.thumbnailPath,
    required this.beforeImagePath,
    required this.afterImagePath,
  });
}

class TryOnScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSaveLook;

  const TryOnScreen({super.key, this.onBack, this.onSaveLook});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  int _selectedIndex = 0;

  static const _styles = [
    _StyleOption(
      name: 'Layer Cut',
      thumbnailPath: 'assets/images/hair_layer_cut.png',
      beforeImagePath: 'assets/images/try_on_before.png',
      afterImagePath: 'assets/images/hair_layer_cut_tryon.png',
    ),
    _StyleOption(
      name: 'Curtain Bangs',
      thumbnailPath: 'assets/images/hair_curtain_bangs.png',
      beforeImagePath: 'assets/images/try_on_before.png',
      afterImagePath: 'assets/images/hair_curtain_bangs_tryon.png',
    ),
    _StyleOption(
      name: 'Wolf Cut',
      thumbnailPath: 'assets/images/hair_wolf_cut.png',
      beforeImagePath: 'assets/images/try_on_before.png',
      afterImagePath: 'assets/images/hair_wolf_cut_tryon.png',
    ),
    _StyleOption(
      name: 'Long Waves',
      thumbnailPath: 'assets/images/hair_long_waves.png',
      beforeImagePath: 'assets/images/try_on_before.png',
      afterImagePath: 'assets/images/hair_long_waves_tryon.png',
    ),
  ];

  static const _bg = Color(0xFFF9EFF2);
  static const _cardBg = Color(0xFFFBF0F3);
  static const _pink = Color(0xFF8B2252);
  static const _textDark = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final current = _styles[_selectedIndex];

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.014),

            // ── Screen title ─────────────────────────────────────
            Text(
              '12. Preview / Try-On',
              style: GoogleFonts.playfairDisplay(
                fontSize: _s(w, 18),
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),

            SizedBox(height: h * 0.018),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                child: Container(
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
                    children: [
                      SizedBox(height: h * 0.020),

                      // ── Card title ──────────────────────────────
                      Text(
                        'Try-On Preview',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: _s(w, 17),
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),

                      SizedBox(height: h * 0.016),

                      // ── Split preview ───────────────────────────
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                          child: _SplitPreview(
                            beforePath: current.beforeImagePath,
                            afterPath: current.afterImagePath,
                            onPrev: _selectedIndex > 0
                                ? () => setState(() => _selectedIndex--)
                                : null,
                            onNext: _selectedIndex < _styles.length - 1
                                ? () => setState(() => _selectedIndex++)
                                : null,
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.018),

                      // ── Style selector ──────────────────────────
                      SizedBox(
                        height: h * 0.115,
                        child: _StyleSelector(
                          styles: _styles,
                          selectedIndex: _selectedIndex,
                          onSelect: (i) => setState(() => _selectedIndex = i),
                        ),
                      ),

                      SizedBox(height: h * 0.020),

                      // ── Save Look button ────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        child: _SaveButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SavedLooksScreen(),
                              ),
                            );
                          },
                          w: w,
                        ),
                      ),

                      SizedBox(height: h * 0.022),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: h * 0.018),
          ],
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Split Before / After Preview
// ─────────────────────────────────────────────────────────────
class _SplitPreview extends StatelessWidget {
  final String beforePath;
  final String afterPath;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _SplitPreview({
    required this.beforePath,
    required this.afterPath,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          // Before (left half) + After (right half)
          Row(
            children: [
              Expanded(
                child: _HalfImage(
                  imagePath: beforePath,
                  alignment: Alignment.topLeft,
                  clipLeft: true,
                ),
              ),
              Expanded(
                child: _HalfImage(
                  imagePath: afterPath,
                  alignment: Alignment.topRight,
                  clipLeft: false,
                ),
              ),
            ],
          ),

          // Center divider line
          Positioned.fill(
            child: Center(
              child: Container(
                width: 2,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),

          // Left nav arrow
          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: _NavArrow(icon: Icons.chevron_left_rounded, onTap: onPrev),
            ),
          ),

          // Right nav arrow
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: _NavArrow(
                icon: Icons.chevron_right_rounded,
                onTap: onNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfImage extends StatelessWidget {
  final String imagePath;
  final Alignment alignment;
  final bool clipLeft;

  const _HalfImage({
    required this.imagePath,
    required this.alignment,
    required this.clipLeft,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        alignment: alignment,
        child: Image.asset(
          imagePath,
          errorBuilder: (_, _, _) => Container(
            width: 200,
            height: 300,
            color: const Color(0xFFF0DDE4),
            child: Icon(
              Icons.person_outline_rounded,
              size: 60,
              color: const Color(0xFFCB8FA8).withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NavArrow({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap != null ? 1.0 : 0.35,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: const Color(0xFF1C1C1C)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Style Selector — horizontal scroll with thumbnails
// ─────────────────────────────────────────────────────────────
class _StyleSelector extends StatelessWidget {
  final List<_StyleOption> styles;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _StyleSelector({
    required this.styles,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      itemCount: styles.length,
      itemBuilder: (context, i) {
        final style = styles[i];
        final selected = i == selectedIndex;

        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: w * 0.030),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thumbnail
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: w * 0.165,
                  height: w * 0.165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF8B2252)
                          : Colors.transparent,
                      width: 2.5,
                    ),
                    color: const Color(0xFFF0DDE4),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF8B2252,
                              ).withValues(alpha: 0.22),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    style.thumbnailPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFF0DDE4),
                      child: const Icon(
                        Icons.face_retouching_natural_outlined,
                        size: 28,
                        color: Color(0xFFCB8FA8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Label
                SizedBox(
                  width: w * 0.165,
                  child: Text(
                    style.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: _s(w, 10.5),
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected
                          ? const Color(0xFF8B2252)
                          : const Color(0xFF9B7C88),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Save Look Button
// ─────────────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double w;

  const _SaveButton({this.onTap, required this.w});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFF8B2252),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B2252).withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'Save Look',
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
