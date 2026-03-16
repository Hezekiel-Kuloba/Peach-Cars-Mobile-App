import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/providers/wishlist_provider.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/bottom_nav.dart';
import 'package:peach_cars/widgets/car_card.dart';
import 'package:peach_cars/widgets/common.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final wishlist = ref.watch(wishlistProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.yourWishlist,
                style: Theme.of(context).appBarTheme.titleTextStyle),
            Text(t.favouriteCars,
                style: const TextStyle(
                    color: PeachColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      bottomNavigationBar: const PeachBottomNav(currentIndex: 1),
      body: wishlist.isEmpty
          ? PeachEmptyState(
              icon: Icons.bookmark_border_rounded,
              title: t.noWishlistItems,
              subtitle: t.addCarsToWishlist,
              buttonLabel: t.buyCar,
              onButton: () =>
                  NavigationService.pushReplacementNamed(AppRoutes.buyCar),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => CarCard(car: wishlist[i]),
                      childCount: wishlist.length,
                    ),
                  ),
                ),

                // CTA card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: GestureDetector(
                      onTap: () => NavigationService.pushReplacementNamed(
                          AppRoutes.buyCar),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              PeachColors.primaryDark,
                              PeachColors.primary
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.search_rounded,
                                color: Colors.white, size: 32),
                            const SizedBox(height: 8),
                            Text(t.findMoreCars,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 4),
                            Text(t.exploreMoreCars,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 13),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
