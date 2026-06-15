import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// PALETTE
// ═══════════════════════════════════════════════════════════════════════════════

abstract class _Palette {
  static const background   = Color(0xFFFBE9E9);
  static const darkText     = Color(0xFF2D1B2E);
  static const subtleText   = Color(0xFF9C8A8A);
  static const rowDivider   = Color(0xFFF0DFDF);
  static const buttonRose   = Color(0xFFAD5070);

  /// ≈ 55 % white — keeps table translucent over the pink bg
  static const tableOverlay = Color(0x8DFFFFFF);
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPARE SCREEN  ·  public entry point
// ═══════════════════════════════════════════════════════════════════════════════

class CompareScreen extends StatelessWidget {
  /// Fired when the user taps "Save Comparison".
  final VoidCallback? onSave;

  /// Fired when the user taps the back arrow.
  final VoidCallback? onBack;

  const CompareScreen({
    super.key,
    this.onSave,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CompareAppBar(onBack: onBack),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const _HairstyleImagesRow(),
                    const SizedBox(height: 26),
                    const _ComparisonTable(),
                    const SizedBox(height: 36),
                    _SaveButton(onPressed: onSave),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP BAR
// ═══════════════════════════════════════════════════════════════════════════════

class _CompareAppBar extends StatelessWidget {
  final VoidCallback? onBack;

  const _CompareAppBar({this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (onBack != null)
            Align(
              alignment: Alignment.centerLeft,
              child: _BackIconButton(onTap: onBack!),
            ),
          Text(
            'Compare Hairstyles',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _Palette.darkText,
            ),
          ),
          // Mirror spacer keeps title visually centred when back button shown
          if (onBack != null)
            const Align(
              alignment: Alignment.centerRight,
              child: SizedBox(width: 38, height: 38),
            ),
        ],
      ),
    );
  }
}

class _BackIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 15,
          color: _Palette.darkText,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HAIRSTYLE IMAGE CARDS ROW
// ═══════════════════════════════════════════════════════════════════════════════

class _HairstyleImagesRow extends StatelessWidget {
  const _HairstyleImagesRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _HairstyleImageCard(
            label: 'Layer Cut',
            imagePath: 'assets/images/hairstyle_layer_cut.png',
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _HairstyleImageCard(
            label: 'Curtain Bangs',
            imagePath: 'assets/images/hairstyle_curtain_bangs.png',
          ),
        ),
      ],
    );
  }
}

class _HairstyleImageCard extends StatelessWidget {
  final String label;
  final String imagePath;

  const _HairstyleImageCard({
    required this.label,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive height: ~44 % of half-screen width for portrait
    final imageH = MediaQuery.of(context).size.width * 0.44;

    return Column(
      children: [
        _StyleLabelChip(text: label),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: imageH,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _ImageFallback(height: imageH),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Style Label Chip  (white pill above each image)
// ─────────────────────────────────────────────────────────────────────────────

class _StyleLabelChip extends StatelessWidget {
  final String text;

  const _StyleLabelChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _Palette.darkText,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Image Fallback  (shown when asset is missing during development)
// ─────────────────────────────────────────────────────────────────────────────

class _ImageFallback extends StatelessWidget {
  final double height;

  const _ImageFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF5DEDE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.face_retouching_natural_outlined,
        size: 52,
        color: Color(0xFFD4A0A0),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPARISON TABLE
// ═══════════════════════════════════════════════════════════════════════════════

/// Lightweight, immutable row descriptor.
class _RowData {
  final String label;
  final String value1;
  final String value2;

  const _RowData({
    required this.label,
    required this.value1,
    required this.value2,
  });
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable();

  static const List<_RowData> _rows = [
    _RowData(label: 'Suitability',  value1: '94%',         value2: '89%'),
    _RowData(label: 'Maintenance',  value1: 'Medium',      value2: 'Low'),
    _RowData(label: 'Styling Time', value1: '10 min',      value2: '5 min'),
    _RowData(label: 'Best For',     value1: 'Oval, Heart', value2: 'Oval,\nRound'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _Palette.tableOverlay,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _rows.length,
          (i) => _TableRow(
            data: _rows[i],
            showDivider: i < _rows.length - 1,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual Table Row
// ─────────────────────────────────────────────────────────────────────────────

class _TableRow extends StatelessWidget {
  final _RowData data;
  final bool showDivider;

  const _TableRow({
    required this.data,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Label column — ~45 % of row
              Expanded(
                flex: 45,
                child: Text(
                  data.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _Palette.subtleText,
                  ),
                ),
              ),
              // Value 1 column — ~27.5 % of row
              Expanded(
                flex: 27,
                child: Text(
                  data.value1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _Palette.darkText,
                  ),
                ),
              ),
              // Value 2 column — ~27.5 % of row
              Expanded(
                flex: 27,
                child: Text(
                  data.value2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _Palette.darkText,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: _Palette.rowDivider,
            indent: 18,
            endIndent: 18,
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SAVE COMPARISON BUTTON
// ═══════════════════════════════════════════════════════════════════════════════

class _SaveButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _SaveButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _Palette.buttonRose,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          'Save Comparison',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}