import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/models/car.dart';
import 'package:peach_cars/providers/wishlist_provider.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';

class CarCard extends ConsumerWidget {
  final Car car;
  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(wishlistIdsProvider).contains(car.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () =>
          NavigationService.pushNamed(AppRoutes.carDetail, arguments: car.id),
      // ClipRect ensures nothing bleeds outside the rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? PeachColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Column must be mainAxisSize.max so it fills the
          // fixed-height box given by the grid — never min!
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // ── Fixed-height image ─────────────────────────────
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 115,
                    child: car.images.isNotEmpty
                        ? Image.asset(
                            car.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  if (car.isEasterDeal)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: _badge('Easter Deal', PeachColors.primary),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(wishlistProvider.notifier).toggle(car),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav
                              ? PeachColors.primary
                              : PeachColors.grey,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Expanded text area fills the rest of the cell ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Car name
                      Text(
                        '${car.make} ${car.model} ${car.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Mileage / engine
                      Text(
                        '${car.mileageFormatted} · ${car.engineCc}cc',
                        style: const TextStyle(
                          fontSize: 10,
                          color: PeachColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Price
                      Text(
                        car.priceFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: PeachColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Used status badge row
                      Row(
                        children: [
                          Flexible(child: _usedBadge(car.usedStatus)),
                          if (car.financingAvailable) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.account_balance_outlined,
                              size: 11,
                              color: PeachColors.accent,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: PeachColors.lightGrey,
        child: const Center(
          child: Icon(Icons.directions_car,
              size: 36, color: PeachColors.grey),
        ),
      );

  Widget _badge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700),
        ),
      );

  Widget _usedBadge(String status) {
    final isLocal = status == 'Locally Used';
    final color = isLocal ? PeachColors.grey : PeachColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: color, fontSize: 9, fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}