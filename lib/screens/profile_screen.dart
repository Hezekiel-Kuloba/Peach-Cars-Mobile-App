import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/providers/locale_provider.dart';
import 'package:peach_cars/providers/theme_provider.dart';
import 'package:peach_cars/providers/user_provider.dart';
import 'package:peach_cars/providers/wishlist_provider.dart';
import 'package:peach_cars/providers/car_provider.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/bottom_nav.dart';
import 'package:peach_cars/widgets/car_card.dart';
import 'package:peach_cars/widgets/trust_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final wishlist = ref.watch(wishlistProvider);
    final recentlyViewed = ref.watch(recentlyViewedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      bottomNavigationBar: const PeachBottomNav(currentIndex: 4),
      body: CustomScrollView(
        slivers: [
          // ── Header with logo + icon buttons ──────────────────────
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 12, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [PeachColors.primaryDark, PeachColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: logo + icon buttons
                  Row(
                    children: [
                      // Peach Cars logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/logo/peach_logo.jpg',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.pets,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'peach cars',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      // Dark mode toggle icon button
                      _HeaderIconBtn(
                        icon: themeMode == ThemeMode.dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        tooltip: themeMode == ThemeMode.dark
                            ? 'Switch to light mode'
                            : 'Switch to dark mode',
                        onTap: () => ref
                            .read(themeProvider.notifier)
                            .setTheme(themeMode == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark),
                      ),
                      const SizedBox(width: 8),
                      // Language picker icon button
                      _HeaderIconBtn(
                        icon: Icons.language_rounded,
                        tooltip: 'Change language',
                        onTap: () => _showLanguagePicker(
                            context, ref, locale, t),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // User info row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          user != null && user.firstName.isNotEmpty
                              ? user.firstName[0].toUpperCase()
                              : 'G',
                          style: const TextStyle(
                              color: PeachColors.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user != null
                                  ? '${t.welcomeBack}, ${user.firstName}!'
                                  : t.welcomeBack,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              user?.email ?? t.signInToContinue,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Personal details ─────────────────────────────
                  if (user != null) ...[
                    _SectionTitle(t.personalDetails),
                    const SizedBox(height: 10),
                    _ProfileCard(children: [
                      _ProfileRow(Icons.person_outline, t.fullName,
                          user.fullName),
                      const Divider(height: 1),
                      _ProfileRow(Icons.phone_outlined, t.phoneNumber,
                          user.phoneNumber),
                      const Divider(height: 1),
                      _ProfileRow(
                          Icons.email_outlined, t.email, user.email),
                      const Divider(height: 1),
                      _ProfileRow(
                          Icons.lock_outline, t.password, '••••••••'),
                    ]),
                    const SizedBox(height: 20),
                  ],

                  // ── Guest: auth buttons ───────────────────────────
                  if (user == null) ...[
                    _ProfileCard(children: [
                      ListTile(
                        leading: const Icon(Icons.login_rounded,
                            color: PeachColors.primary),
                        title: Text(t.signIn),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            NavigationService.pushNamed(AppRoutes.login),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.person_add_outlined,
                            color: PeachColors.primary),
                        title: Text(t.register),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => NavigationService.pushNamed(
                            AppRoutes.register),
                      ),
                    ]),
                    const SizedBox(height: 20),
                  ],

                  // ── Wishlist preview ──────────────────────────────
                  if (wishlist.isNotEmpty) ...[
                    _SectionTitle(
                      '${t.wishlist} (${wishlist.length})',
                      actionLabel: 'See all',
                      onAction: () => NavigationService.pushReplacementNamed(
                          AppRoutes.wishlist),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: wishlist.take(5).length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) => SizedBox(
                            width: 165,
                            child: CarCard(car: wishlist[i])),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Recently viewed ───────────────────────────────
                  if (recentlyViewed.isNotEmpty) ...[
                    _SectionTitle(t.recentlyViewedCars),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recentlyViewed.take(5).length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) => SizedBox(
                            width: 165,
                            child: CarCard(car: recentlyViewed[i])),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Peach pages ───────────────────────────────────
                  _SectionTitle('Peach Cars'),
                  const SizedBox(height: 10),
                  _ProfileCard(children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline,
                          color: PeachColors.primary),
                      title: Text(t.peachProcesses),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => NavigationService.pushNamed(
                          AppRoutes.peachProcesses),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.people_alt_outlined,
                          color: PeachColors.primary),
                      title: Text(t.referAFriend),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => NavigationService.pushNamed(
                          AppRoutes.referFriend),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ── Settings ─────────────────────────────────────
                  _SectionTitle(t.settings),
                  const SizedBox(height: 10),
                  _ProfileCard(children: [
                    // Dark mode
                    ListTile(
                      leading: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: PeachColors.primary,
                      ),
                      title: Text(t.darkMode),
                      trailing: Switch(
                        value: themeMode == ThemeMode.dark,
                        activeColor: PeachColors.primary,
                        onChanged: (v) => ref
                            .read(themeProvider.notifier)
                            .setTheme(
                                v ? ThemeMode.dark : ThemeMode.light),
                      ),
                    ),
                    const Divider(height: 1),
                    // Language
                    ListTile(
                      leading: const Icon(Icons.language_rounded,
                          color: PeachColors.primary),
                      title: Text(t.language),
                      subtitle: Text(
                        locale.languageCode == 'en'
                            ? t.english
                            : locale.languageCode == 'fr'
                                ? t.french
                                : t.swahili,
                        style: const TextStyle(
                            color: PeachColors.grey, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showLanguagePicker(
                          context, ref, locale, t),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ── Trust card ────────────────────────────────────
                  const PeachTrustCard(),
                  const SizedBox(height: 16),
                  const PeachSupportCard(),
                  const SizedBox(height: 20),

                  // ── Logout ────────────────────────────────────────
                  if (user != null)
                    OutlinedButton.icon(
                      onPressed: () async {
                        await ref.read(userProvider.notifier).logout();
                        NavigationService.pushNamedAndRemoveUntil(
                            AppRoutes.login);
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(t.logout),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PeachColors.error,
                        side: const BorderSide(color: PeachColors.error),
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Language picker bottom sheet ──────────────────────────────────────────
void _showLanguagePicker(BuildContext context, WidgetRef ref,
    Locale currentLocale, AppLocalizations t) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? PeachColors.darkSurface
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: PeachColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text(t.language,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 16),
          for (final entry in [
            ['en', '🇬🇧', 'English'],
            ['fr', '🇫🇷', 'Français'],
            ['sw', '🇰🇪', 'Kiswahili'],
          ])
            ListTile(
              leading: Text(entry[1], style: const TextStyle(fontSize: 24)),
              title: Text(entry[2],
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: currentLocale.languageCode == entry[0]
                  ? const Icon(Icons.check_circle_rounded,
                      color: PeachColors.primary)
                  : null,
              onTap: () {
                ref
                    .read(localeProvider.notifier)
                    .changeLocale(Locale(entry[0]));
                Navigator.pop(context);
              },
            ),
        ],
      ),
    ),
  );
}

// ── Helper widgets ────────────────────────────────────────────────────────
class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _HeaderIconBtn(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _SectionTitle(this.title, {this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;
  const _ProfileCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? PeachColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: PeachColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: PeachColors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}