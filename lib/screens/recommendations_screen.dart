import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hairstyle_detail_screen.dart';

// ─────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────
class _HairStyle {
  final String name;
  final String match;
  final String imagePath;
  final String category;
  bool saved;

  _HairStyle({
    required this.name,
    required this.match,
    required this.imagePath,
    required this.category,
    this.saved = false,
  });
}

class RecommendationsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onHome;
  final VoidCallback? onExplore;
  final VoidCallback? onAdd;
  final VoidCallback? onSaved;
  final VoidCallback? onProfile;
  final void Function(_HairStyle style)? onStyleTap;

  const RecommendationsScreen({
    super.key,
    this.onBack,
    this.onHome,
    this.onExplore,
    this.onAdd,
    this.onSaved,
    this.onProfile,
    this.onStyleTap,
  });

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  int _selectedNav = 0;
  String _selectedFilter = 'All';

  static const _filters = ['All', 'Female', 'Trendy', 'Short', 'Long'];

  final List<_HairStyle> _allStyles = [
    _HairStyle(
      name: 'Layer Cut',
      match: '94% Match',
      imagePath: 'assets/images/hair_layer_cut.png',
      category: 'Female',
    ),
    _HairStyle(
      name: 'Curtain Bangs',
      match: '91% Match',
      imagePath: 'assets/images/hair_curtain_bangs.png',
      category: 'Trendy',
    ),
    _HairStyle(
      name: 'Butterfly Cut',
      match: '99% Match',
      imagePath: 'assets/images/hair_butterfly_cut.png',
      category: 'Trendy',
      saved: true,
    ),
    _HairStyle(
      name: 'Long Waves',
      match: '89% Match',
      imagePath: 'assets/images/hair_long_waves.png',
      category: 'Long',
    ),
    _HairStyle(
      name: 'Wolf Cut',
      match: '87% Match',
      imagePath: 'assets/images/hair_wolf_cut.png',
      category: 'Trendy',
      saved: true,
    ),
    _HairStyle(
      name: 'Shaggy Layers',
      match: '86% Match',
      imagePath: 'assets/images/hair_shaggy_layers.png',
      category: 'Short',
    ),
  ];

  List<_HairStyle> get _filtered => _selectedFilter == 'All'
      ? _allStyles
      : _allStyles.where((s) => s.category == _selectedFilter).toList();

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
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // ── App bar ────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _TopBar(onBack: widget.onBack, w: w, h: h),
                  ),

                  // ── Title ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.055),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Recommended for You',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: _s(w, 22),
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1C1C1C),
                            ),
                          ),
                          SizedBox(height: h * 0.022),

                          // ── Filter chips ───────────────────────
                          _FilterRow(
                            filters: _filters,
                            selected: _selectedFilter,
                            onSelect: (f) =>
                                setState(() => _selectedFilter = f),
                          ),
                          SizedBox(height: h * 0.024),
                        ],
                      ),
                    ),
                  ),

                  // ── Grid ──────────────────────────────────────
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final style = _filtered[index];
                        return _StyleCard(
                          style: style,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HairstyleDetailScreen(),
                              ),
                            );
                          },
                          onToggleSave: () =>
                              setState(() => style.saved = !style.saved),
                        );
                      }, childCount: _filtered.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: w * 0.025,
                        mainAxisSpacing: w * 0.025,
                        childAspectRatio: 0.62,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: h * 0.02)),
                ],
              ),
            ),

            // ── Bottom Nav ────────────────────────────────────────
            _BottomNav(
              selectedIndex: _selectedNav,
              onTap: (i) {
                setState(() => _selectedNav = i);
                if (i == 0) widget.onHome?.call();
                if (i == 1) widget.onExplore?.call();
                if (i == 2) widget.onAdd?.call();
                if (i == 3) widget.onSaved?.call();
                if (i == 4) widget.onProfile?.call();
              },
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
// Top Bar
// ─────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback? onBack;
  final double w, h;

  const _TopBar({this.onBack, required this.w, required this.h});

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
          const Spacer(),
          Text(
            '10. Recommendations',
            style: GoogleFonts.playfairDisplay(
              fontSize: _s(w, 17),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1C1C),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Filter Row
// ─────────────────────────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  const _FilterRow({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = f == selected;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF8B2252)
                    : const Color(0xFFFBF0F3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF8B2252)
                      : const Color(0xFFE8C4D0),
                  width: 1.2,
                ),
              ),
              child: Text(
                f,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF1C1C1C),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Style Card
// ─────────────────────────────────────────────────────────────
class _StyleCard extends StatelessWidget {
  final _HairStyle style;
  final VoidCallback? onTap;
  final VoidCallback? onToggleSave;

  const _StyleCard({required this.style, this.onTap, this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFBF0F3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCB8FA8).withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with heart overlay
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      style.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFF0DDE4),
                        child: const Icon(
                          Icons.face_retouching_natural_outlined,
                          size: 30,
                          color: Color(0xFFCB8FA8),
                        ),
                      ),
                    ),
                  ),
                  // Heart button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onToggleSave,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: style.saved
                              ? const Color(0xFF8B2252)
                              : Colors.white.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          style.saved
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          size: 15,
                          color: style.saved
                              ? Colors.white
                              : const Color(0xFF8B2252),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Labels
            Padding(
              padding: EdgeInsets.fromLTRB(
                w * 0.022,
                w * 0.018,
                w * 0.014,
                w * 0.018,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: _s(w, 11.5),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1C1C1C),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    style.match,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: _s(w, 10.5),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8B2252),
                    ),
                  ),
                ],
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
// Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  static const _pink = Color(0xFF8B2252);
  static const _inactive = Color(0xFFBFA0AE);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            selected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.search_rounded,
            label: 'Explore',
            selected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: _pink,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x338B2252),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
          _NavItem(
            icon: Icons.bookmark_outline_rounded,
            label: 'Saved',
            selected: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            selected: selectedIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF8B2252) : const Color(0xFFBFA0AE);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.playfairDisplay(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
