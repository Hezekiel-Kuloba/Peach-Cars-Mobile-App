import 'package:flutter/material.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:flutter/material.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:flutter/material.dart';

/// Bottom navigation bar with a floating pink chat button.
/// The chat button sits ABOVE the nav bar so it never covers any label.
///
/// Usage: bottomNavigationBar: const PeachBottomNav(currentIndex: 0)
class PeachBottomNav extends StatelessWidget {
  final int currentIndex;
  const PeachBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return _PeachBottomNavInner(currentIndex: currentIndex);
  }
}

// ignore: must_be_immutable — simple stateless wrapper
class _PeachBottomNavInner extends StatelessWidget {
  final int currentIndex;
  const _PeachBottomNavInner({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    // Height of the actual nav bar
    const navBarHeight = 60.0;
    // Chat FAB diameter
    const fabSize = 50.0;
    // Gap between top of nav bar and bottom of FAB
    const fabOverlap = 8.0;

    return SizedBox(
      // Total height = nav bar + system bottom padding
      height: navBarHeight + bottomPad,
      child: Stack(
        clipBehavior: Clip.none, // allow FAB to poke above
        children: [
          // ── Nav bar ─────────────────────────────────────────────
          Positioned.fill(
            child: Material(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              elevation: 12,
              shadowColor: Colors.black26,
              child: Column(
                children: [
                  // The actual tappable items row
                  SizedBox(
                    height: navBarHeight,
                    child: Row(
                      children: [
                        _NavItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          label: t.home,
                          selected: currentIndex == 0,
                          onTap: () => _go(context, 0),
                        ),
                        _NavItem(
                          icon: Icons.bookmark_border_rounded,
                          activeIcon: Icons.bookmark_rounded,
                          label: t.wishlist,
                          selected: currentIndex == 1,
                          onTap: () => _go(context, 1),
                        ),
                        _NavItem(
                          icon: Icons.directions_car_outlined,
                          activeIcon: Icons.directions_car,
                          label: t.buyCar,
                          selected: currentIndex == 2,
                          onTap: () => _go(context, 2),
                        ),
                        _NavItem(
                          icon: Icons.sell_outlined,
                          activeIcon: Icons.sell,
                          label: t.sellCar,
                          selected: currentIndex == 3,
                          onTap: () => _go(context, 3),
                        ),
                        _NavItem(
                          icon: Icons.person_outline_rounded,
                          activeIcon: Icons.person_rounded,
                          label: t.profile,
                          selected: currentIndex == 4,
                          onTap: () => _go(context, 4),
                        ),
                      ],
                    ),
                  ),
                  // System safe area fill
                  SizedBox(height: bottomPad),
                ],
              ),
            ),
          ),

          // ── Pink chat FAB — floats ABOVE the nav bar ─────────────
          Positioned(
            // bottom edge of FAB = top of nav bar + fabOverlap (above it)
            bottom: navBarHeight + bottomPad + fabOverlap - fabSize / 2,
            right: 16,
            child: GestureDetector(
              onTap: () {
                // TODO: open chat / WhatsApp
              },
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  color: PeachColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: PeachColors.primary.withOpacity(0.45),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0: NavigationService.pushReplacementNamed(AppRoutes.home); break;
      case 1: NavigationService.pushReplacementNamed(AppRoutes.wishlist); break;
      case 2: NavigationService.pushReplacementNamed(AppRoutes.buyCar); break;
      case 3: NavigationService.pushReplacementNamed(AppRoutes.sellCar); break;
      case 4: NavigationService.pushReplacementNamed(AppRoutes.profile); break;
    }
  }
}

// ── Individual nav item ───────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? PeachColors.primary : PeachColors.grey;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}