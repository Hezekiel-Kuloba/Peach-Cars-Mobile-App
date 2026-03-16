import 'package:flutter/material.dart';
import 'package:peach_cars/utilites/theme.dart';

/// Standard Peach Cars AppBar with the peach logo + wordmark.
class PeachAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final Color? backgroundColor;

  const PeachAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor:
          backgroundColor ?? (isDark ? PeachColors.darkSurface : PeachColors.lightSurface),
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      leading: leading,
      title: showLogo
          ? _PeachLogo(isDark: isDark)
          : title != null
              ? Text(title!, style: theme.appBarTheme.titleTextStyle)
              : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class _PeachLogo extends StatelessWidget {
  final bool isDark;
  const _PeachLogo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Peach icon — circular pink icon placeholder
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: PeachColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.directions_car,
              color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        Text(
          'peach cars',
          style: TextStyle(
            color: isDark ? PeachColors.darkText : PeachColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

/// Slim top bar with phone number + user name (like real Peach Cars site)
class PeachTopBar extends StatelessWidget {
  final String? userName;
  final VoidCallback? onUserTap;

  const PeachTopBar({super.key, this.userName, this.onUserTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.grey.withOpacity(0.07),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.phone, size: 14, color: PeachColors.grey),
          const SizedBox(width: 4),
          const Text(
            'Call: 0709 726900',
            style: TextStyle(fontSize: 12, color: PeachColors.grey),
          ),
          const Spacer(),
          if (userName != null) ...[
            const Icon(Icons.person_outline, size: 14, color: PeachColors.grey),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onUserTap,
              child: Text(
                userName!,
                style: const TextStyle(
                  fontSize: 12,
                  color: PeachColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.power_settings_new,
                size: 14, color: PeachColors.grey),
          ],
        ],
      ),
    );
  }
}
