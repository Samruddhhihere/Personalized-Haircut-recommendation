import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedLooksScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final void Function(int index)? onLookTap;

  const SavedLooksScreen({
    super.key,
    this.onBack,
    this.onLookTap,
  });

  @override
  State<SavedLooksScreen> createState() => _SavedLooksScreenState();
}

class _SavedLooksScreenState extends State<SavedLooksScreen> {
  // Track favourite state for each look
  final List<bool> _favourites = [true, false, true, true];

  static const List<String> _assetPaths = [
    'assets/images/hair_butterfly_cut.png',
    'assets/images/hair_curtain_bangs.png',
    'assets/images/hair_layer_cut.png',
    'assets/images/hair_wolf_cut.png',
  ];

  void _toggleFavourite(int index) {
    setState(() {
      _favourites[index] = !_favourites[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(onBack: widget.onBack),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                child: _LooksGrid(
                  assetPaths: _assetPaths,
                  favourites: _favourites,
                  onToggleFavourite: _toggleFavourite,
                  onLookTap: widget.onLookTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback? onBack;

  const _TopBar({this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: const Color(0xFF2D1B1B),
            splashRadius: 22,
          ),
          const SizedBox(width: 4),
          Text(
            'Saved Looks',
            style: GoogleFonts.dmSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D1B1B),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Grid
// ─────────────────────────────────────────────
class _LooksGrid extends StatelessWidget {
  final List<String> assetPaths;
  final List<bool> favourites;
  final void Function(int) onToggleFavourite;
  final void Function(int)? onLookTap;

  const _LooksGrid({
    required this.assetPaths,
    required this.favourites,
    required this.onToggleFavourite,
    this.onLookTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemCount: assetPaths.length,
      itemBuilder: (context, index) {
        return _LookCard(
          assetPath: assetPaths[index],
          isFavourite: favourites[index],
          onToggleFavourite: () => onToggleFavourite(index),
          onTap: onLookTap != null ? () => onLookTap!(index) : null,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Individual card
// ─────────────────────────────────────────────
class _LookCard extends StatelessWidget {
  final String assetPath;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;
  final VoidCallback? onTap;

  const _LookCard({
    required this.assetPath,
    required this.isFavourite,
    required this.onToggleFavourite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD9A8A8).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Photo ──
              Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),

              // ── Subtle gradient overlay so the heart pops ──
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Heart button ──
              Positioned(
                top: 10,
                left: 10,
                child: _HeartButton(
                  isFavourite: isFavourite,
                  onTap: onToggleFavourite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Heart button
// ─────────────────────────────────────────────
class _HeartButton extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onTap;

  const _HeartButton({
    required this.isFavourite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isFavourite),
              color: isFavourite
                  ? const Color(0xFFE8637A)
                  : const Color(0xFFBBABAB),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}