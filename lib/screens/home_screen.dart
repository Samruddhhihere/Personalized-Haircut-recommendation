import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'upload_photo_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _pink = Color(0xFF8B2252);
  static const _bg = Color(0xFFF9EFF2);
  static const _cardBg = Color(0xFFF5E2E8);
  static const _chipBg = Color(0xFFFBF0F3);
  static const _textDark = Color(0xFF1C1C1C);
  static const _textMid = Color(0xFF9B7C88);
  static const _divider = Color(0xFFEDD5DE);

  /// Returns the greeting name based on Firebase Auth state:
  /// 1. displayName, 2. email prefix before '@', 3. "Guest"
  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'Guest';
    }

    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }

    if (user.email != null && user.email!.contains('@')) {
      return user.email!.split('@').first;
    }

    return 'Guest';
  }

  void _navigateToUploadPhoto() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadPhotoScreen(),
      ),
    );
  }

  void _navigateToSaved() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SavedLooksScreen(),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final userName = _getUserName();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.022),

                    // ── Top Bar ──────────────────────────────────
                    _TopBar(
                      userName: userName,
                      w: w,
                    ),

                    SizedBox(height: h * 0.022),

                    // ── Hero Banner ──────────────────────────────
                    _HeroBanner(
                      onTryNow: _navigateToUploadPhoto,
                      w: w,
                      h: h,
                    ),

                    SizedBox(height: h * 0.028),

                    // ── Quick Actions ────────────────────────────
                    Text(
                      'Quick Actions',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: _s(w, 18),
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                      ),
                    ),

                    SizedBox(height: h * 0.018),

                    _QuickActions(
                      onTryNew: _navigateToUploadPhoto,
                      onSaved: _navigateToSaved,
                      onCompare: () {},
                      w: w,
                    ),

                    SizedBox(height: h * 0.028),

                    // ── Recommended for You ──────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended for You',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: _s(w, 18),
                            fontWeight: FontWeight.w800,
                            color: _textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'See All',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: _s(w, 14),
                              fontWeight: FontWeight.w700,
                              color: _pink,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.016),

                    _RecommendedGrid(
                      onTap: () {},
                      w: w,
                    ),

                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),

            // ── Bottom Nav ───────────────────────────────────────
            _BottomNav(
              selectedIndex: _selectedIndex,
              onTap: (i) {
                setState(() => _selectedIndex = i);

                switch (i) {
                  case 0:
                    // Home — already here, no navigation needed
                    break;
                  case 1:
                    // Explore — no screen specified, no-op
                    break;
                  case 2:
                    _navigateToUploadPhoto();
                    break;
                  case 3:
                    _navigateToSaved();
                    break;
                  case 4:
                    _navigateToProfile();
                    break;
                }
              },
              w: w,
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
  final String userName;
  final double w;

  const _TopBar({required this.userName, required this.w});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hi, $userName ',
                style: GoogleFonts.playfairDisplay(
                  fontSize: _s(w, 22),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1C1C1C),
                ),
              ),
              const TextSpan(
                text: '👋',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
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
                  Icons.notifications_outlined,
                  color: Color(0xFF1C1C1C),
                  size: 22,
                ),
              ),
              Positioned(
                top: 6,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Hero Banner
// ─────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final VoidCallback onTryNow;
  final double w, h;

  const _HeroBanner({required this.onTryNow, required this.w, required this.h});

  static const _pink = Color(0xFF8B2252);
  static const _cardBg = Color(0xFFF2D8E2);

  @override
  Widget build(BuildContext context) {
    final cardH = h * 0.175;

    return Container(
      width: double.infinity,
      height: cardH,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Text + Button
          Positioned(
            left: w * 0.05,
            top: 0,
            bottom: 0,
            width: w * 0.50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'AI Hairstyle Try-On',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 16),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1C1C1C),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: cardH * 0.08),
                Text(
                  'See how you look in\ndifferent hairstyles',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 12),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B3A50),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: cardH * 0.14),
                GestureDetector(
                  onTap: onTryNow,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05, vertical: 9),
                    decoration: BoxDecoration(
                      color: _pink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Try Now',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: _s(w, 13),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Portrait image
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: w * 0.42,
            child: Image.asset(
              'assets/images/onboarding_portrait.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFECC5D4),
                child: const Icon(Icons.person_outline_rounded,
                    size: 60, color: Color(0xFFCB8FA8)),
              ),
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
// Quick Actions Row
// ─────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  final VoidCallback onTryNew;
  final VoidCallback onSaved;
  final VoidCallback onCompare;
  final double w;

  const _QuickActions({
    required this.onTryNew,
    required this.onSaved,
    required this.onCompare,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickActionItem(
        icon: Icons.auto_awesome_outlined,
        label: 'Try New\nHairstyle',
        onTap: onTryNew,
      ),
      _QuickActionItem(
        icon: Icons.bookmark_outline_rounded,
        label: 'Saved\nLooks',
        onTap: onSaved,
      ),
      _QuickActionItem(
        icon: Icons.compare_arrows_rounded,
        label: 'Compare\nStyles',
        onTap: onCompare,
      ),
    ];

    return Row(
      children: items
          .map((item) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.015),
                  child: item,
                ),
              ))
          .toList(),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: w * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF0F3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF5E2E8),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF8B2252), size: 22),
            ),
            SizedBox(height: w * 0.025),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: _s(w, 12),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1C1C),
                height: 1.4,
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
// Recommended Grid (3 cards in a row)
// ─────────────────────────────────────────────────────────────
class _RecommendedGrid extends StatelessWidget {
  final VoidCallback onTap;
  final double w;

  const _RecommendedGrid({required this.onTap, required this.w});

  static const _items = [
    _RecommendedCard(
      imagePath: 'assets/images/hair_layer_cut.png',
      label: 'Layer Cut',
      match: '94%',
    ),
    _RecommendedCard(
      imagePath: 'assets/images/hair_curtain_bangs.png',
      label: 'Curtain Bangs',
      match: '92%',
    ),
    _RecommendedCard(
      imagePath: 'assets/images/hair_butterfly_cut.png',
      label: 'Butterfly Cut',
      match: '90%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _items
          .map((card) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.012),
                  child: GestureDetector(
                    onTap: onTap,
                    child: card,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String match;

  const _RecommendedCard({
    required this.imagePath,
    required this.label,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final imgH = w * 0.30;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBF0F3),
        borderRadius: BorderRadius.circular(14),
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
          SizedBox(
            height: imgH,
            width: double.infinity,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFF0DDE4),
                child: const Icon(Icons.face_retouching_natural_outlined,
                    size: 32, color: Color(0xFFCB8FA8)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                w * 0.02, w * 0.018, w * 0.02, w * 0.018),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 11),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C1C1C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$match Match',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: _s(w, 10),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8B2252),
                  ),
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
// Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double w;

  const _BottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.w,
  });

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
          // Centre FAB
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

  static const _pink = Color(0xFF8B2252);
  static const _inactive = Color(0xFFBFA0AE);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _pink : _inactive;
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