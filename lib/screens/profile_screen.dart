import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfileScreen
// ─────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final VoidCallback? onMyLooksTap;
  final VoidCallback? onMyRoutineTap;
  final VoidCallback? onMyOrdersTap;
  final VoidCallback? onAccountSettingsTap;
  final VoidCallback? onHelpSupportTap;
  final VoidCallback? onAboutTap;

  // Bottom nav callbacks
  final VoidCallback? onHomeTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onSavedTap;

  const ProfileScreen({
    super.key,
    this.onSettingsTap,
    this.onMyLooksTap,
    this.onMyRoutineTap,
    this.onMyOrdersTap,
    this.onAccountSettingsTap,
    this.onHelpSupportTap,
    this.onAboutTap,
    this.onHomeTap,
    this.onExploreTap,
    this.onAddTap,
    this.onSavedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // ── Settings icon ──
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: onSettingsTap,
                          icon: const Icon(
                            Icons.settings_outlined,
                            size: 26,
                            color: Color(0xFF2D1B1B),
                          ),
                          splashRadius: 22,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Profile header ──
                      _ProfileHeader(),

                      const SizedBox(height: 28),

                      // ── Stats row ──
                      const _StatsRow(),

                      const SizedBox(height: 28),

                      // ── Menu ──
                      _MenuSection(
                        items: [
                          _MenuItem(label: 'My Looks',          onTap: onMyLooksTap),
                          _MenuItem(label: 'My Routine',        onTap: onMyRoutineTap),
                          _MenuItem(label: 'My Orders',         onTap: onMyOrdersTap),
                          _MenuItem(label: 'Account Settings',  onTap: onAccountSettingsTap),
                          _MenuItem(label: 'Help & Support',    onTap: onHelpSupportTap),
                          _MenuItem(label: 'About HairVerse AI',onTap: onAboutTap),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom nav ──
            _BottomNav(
              onHomeTap:    onHomeTap,
              onExploreTap: onExploreTap,
              onAddTap:     onAddTap,
              onSavedTap:   onSavedTap,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Header
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE8A0A8), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD98F9A).withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile_avatar.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Name + badge
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aisha Khan',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D1B1B),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFF5A623), size: 16),
                const SizedBox(width: 4),
                Text(
                  'Premium Member',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFF5A623),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9A8A8).withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _StatItem(value: '12', label: 'Looks Saved'),
          _VerticalDivider(),
          _StatItem(value: '5',  label: 'Analyses'),
          _VerticalDivider(),
          _StatItem(value: '24', label: 'Bookmarks'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D1B1B),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9E7E7E),
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: const Color(0xFFEDD9D9),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu
// ─────────────────────────────────────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9A8A8).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Column(
            children: [
              items[i],
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xFFF2E4E4),
                  indent: 20,
                  endIndent: 20,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D1B1B),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFFBB9A9A),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onSavedTap;

  const _BottomNav({
    this.onHomeTap,
    this.onExploreTap,
    this.onAddTap,
    this.onSavedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                onTap: onHomeTap,
              ),
              _NavItem(
                icon: Icons.search_rounded,
                label: 'Explore',
                onTap: onExploreTap,
              ),

              // ── FAB-style centre button ──
              GestureDetector(
                onTap: onAddTap,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFE8637A), Color(0xFFC4405A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE8637A),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                ),
              ),

              _NavItem(
                icon: Icons.bookmark_outline_rounded,
                label: 'Saved',
                onTap: onSavedTap,
              ),

              // Profile — active state
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: true,
                onTap: null, // already on this screen
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFE8637A) : const Color(0xFFAA8888);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}