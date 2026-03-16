import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/models/car.dart';
import 'package:peach_cars/models/requests.dart';
import 'package:peach_cars/providers/car_provider.dart';
import 'package:peach_cars/providers/request_provider.dart';
import 'package:peach_cars/providers/wishlist_provider.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/dialog.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/car_card.dart';
import 'package:peach_cars/widgets/common.dart';
import 'package:peach_cars/widgets/loading.dart';
import 'package:peach_cars/widgets/trust_card.dart';

class CarDetailScreen extends ConsumerStatefulWidget {
  final String carId;
  const CarDetailScreen({super.key, required this.carId});

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen> {
  int _imgIndex = 0;
  final _pageCtrl = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentlyViewedProvider.notifier).addCar(widget.carId);
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final carAsync = ref.watch(carDetailProvider(widget.carId));
    final isFav = ref.watch(wishlistIdsProvider).contains(widget.carId);

    return carAsync.when(
      loading: () => const Scaffold(body: PeachLoader()),
      error: (e, _) => Scaffold(
          appBar: AppBar(), body: Center(child: Text(t.somethingWentWrong))),
      data: (car) => _DetailBody(
        car: car,
        isFav: isFav,
        pageCtrl: _pageCtrl,
        imgIndex: _imgIndex,
        onImgChanged: (i) => setState(() => _imgIndex = i),
      ),
    );
  }
}

// ── Main body ─────────────────────────────────────────────────────────────
class _DetailBody extends ConsumerWidget {
  final Car car;
  final bool isFav;
  final PageController pageCtrl;
  final int imgIndex;
  final ValueChanged<int> onImgChanged;

  const _DetailBody({
    required this.car,
    required this.isFav,
    required this.pageCtrl,
    required this.imgIndex,
    required this.onImgChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final similarAsync = ref.watch(carsNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? PeachColors.darkBg : const Color(0xFFF8F8F8),

      // ── Sticky bottom bar: Make an Enquiry | Request a Viewing | Share ──
      bottomNavigationBar: _BottomActionBar(car: car),

      body: CustomScrollView(
        slivers: [
          // ── Image gallery appbar ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDark ? PeachColors.darkSurface : Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 16),
                  onPressed: () => NavigationService.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined,
                        color: Colors.white, size: 16),
                    onPressed: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 10, 6),
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? PeachColors.primary : Colors.white,
                        size: 16),
                    onPressed: () =>
                        ref.read(wishlistProvider.notifier).toggle(car),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image PageView
                  PageView.builder(
                    controller: pageCtrl,
                    itemCount:
                        car.images.isNotEmpty ? car.images.length : 1,
                    onPageChanged: onImgChanged,
                    itemBuilder: (_, i) {
                      if (car.images.isEmpty) {
                        return _imgPlaceholder();
                      }
                      return Image.asset(
                        car.images[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imgPlaceholder(),
                      );
                    },
                  ),
                  // Thumbnail strip at bottom
                  if (car.images.length > 1)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        color: Colors.black38,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          itemCount: car.images.length,
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => pageCtrl.animateToPage(i,
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                            child: Container(
                              width: 50,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: imgIndex == i
                                        ? PeachColors.primary
                                        : Colors.white38,
                                    width: imgIndex == i ? 2 : 1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  car.images[i],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    // Single image: dot indicator
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          car.images.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: imgIndex == i ? 20 : 6,
                            height: 6,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: imgIndex == i
                                  ? PeachColors.primary
                                  : Colors.white70,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Price + Status row ───────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.priceFormatted,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: PeachColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusChip(car.usedStatus),
                    ],
                  ),
                  const Spacer(),
                  if (car.isEasterDeal) _StatusChip('Easter Deal'),
                ],
              ),
            ),
          ),

          // ── Title + breadcrumb ───────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.home_outlined,
                          size: 13, color: PeachColors.grey),
                      const SizedBox(width: 2),
                      Text(' > ${car.make} > ${car.model}',
                          style: const TextStyle(
                              fontSize: 12, color: PeachColors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quick specs chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SpecChip(Icons.speed_outlined, car.mileageFormatted),
                      _SpecChip(Icons.local_gas_station_outlined,
                          car.fuelType),
                      _SpecChip(
                          Icons.settings_outlined, car.transmission),
                      _SpecChip(Icons.drive_eta_outlined, car.drive),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Verification badges ──────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: _VerificationBadges(car: car),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Description ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About this car',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    car.description,
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.65,
                        color: isDark
                            ? PeachColors.darkText.withOpacity(0.75)
                            : PeachColors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Specs grid ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.basicFeatures,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _SpecsGrid(car: car, t: t),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Salesperson card ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding: const EdgeInsets.all(16),
              child: _SalespersonCard(car: car),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Location section with map ────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  // Map widget (static map placeholder — swap for google_maps_flutter)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        // Map background (static image or real map)
                        Container(
                          height: 260,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0E8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: _StaticMapView(),
                        ),
                        // Location info card overlay (top left)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 2))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Peach Cars - Lavington',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                SizedBox(height: 2),
                                Text('James Gichuru Road',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: PeachColors.grey)),
                                Text('Lavington, Nairobi',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: PeachColors.grey)),
                                SizedBox(height: 8),
                                Text('+254 709 726 900',
                                    style: TextStyle(
                                        color: PeachColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text(
                                  'inquiries@peach-technology.com',
                                  style: TextStyle(
                                      color: PeachColors.primary,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Pink map pin (center)
                        const Positioned(
                          bottom: 60,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Icon(Icons.location_on,
                                color: PeachColors.primary, size: 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Trust card ───────────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PeachTrustCard(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Similar options ──────────────────────────────────────
          similarAsync.when(
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            data: (allCars) {
              final similar = allCars
                  .where((c) => c.id != car.id && c.make == car.make)
                  .take(6)
                  .toList();
              if (similar.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverToBoxAdapter(
                child: Container(
                  color: isDark ? PeachColors.darkSurface : Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.similarOptions,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: similar.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) => SizedBox(
                            width: 170,
                            child: CarCard(car: similar[i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        color: PeachColors.lightGrey,
        child: const Center(
            child: Icon(Icons.directions_car,
                size: 80, color: PeachColors.grey)),
      );
}

// ── Static map view ────────────────────────────────────────────────────────
// Replace with google_maps_flutter widget when adding maps dependency
class _StaticMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Simulated map grid lines
        CustomPaint(painter: _MapGridPainter()),
        // Road lines (decorative)
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                'Map View',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                'Lavington, Nairobi',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCDDCC)
      ..strokeWidth = 1.5;
    // Horizontal roads
    for (double y = 40; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical roads
    for (double x = 50; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Blocks fill
    final blockPaint = Paint()..color = const Color(0xFFDDEEDD);
    canvas.drawRect(
        Rect.fromLTWH(55, 5, 70, 50), blockPaint);
    canvas.drawRect(
        Rect.fromLTWH(140, 65, 80, 50), blockPaint);
    canvas.drawRect(
        Rect.fromLTWH(55, 125, 75, 55), blockPaint);
    canvas.drawRect(
        Rect.fromLTWH(220, 5, 60, 110), blockPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Bottom action bar ─────────────────────────────────────────────────────
class _BottomActionBar extends ConsumerWidget {
  final Car car;
  const _BottomActionBar({required this.car});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: isDark ? PeachColors.darkSurface : Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -3))
        ],
      ),
      child: Row(
        children: [
          // Make an Enquiry — pink filled
          Expanded(
            flex: 5,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: PeachColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              child: Text(t.makeAnEnquiry,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 8),
          // Request a Viewing — outlined pink
          Expanded(
            flex: 5,
            child: OutlinedButton(
              onPressed: () => _showViewingModal(context, ref, car, t),
              style: OutlinedButton.styleFrom(
                foregroundColor: PeachColors.primary,
                side: const BorderSide(color: PeachColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              child: Text(t.requestViewing,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 8),
          // Share icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              border: Border.all(
                  color: PeachColors.primary.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(23),
            ),
            child: IconButton(
              icon: const Icon(Icons.share_outlined,
                  color: PeachColors.primary, size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  const _StatusChip(this.label);

  @override
  Widget build(BuildContext context) {
    final isEaster = label == 'Easter Deal';
    final color =
        isEaster ? PeachColors.primary : PeachColors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SpecChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? PeachColors.darkCard : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: PeachColors.primary),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _VerificationBadges extends StatelessWidget {
  final Car car;
  const _VerificationBadges({required this.car});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (car.sellerVerified)
          _Badge(Icons.verified_rounded, 'Seller verified',
              PeachColors.success),
        if (car.logbookConfirmed)
          _Badge(Icons.book_outlined, 'Logbook confirmed',
              PeachColors.accent),
        _Badge(
          car.vehicleAvailable
              ? Icons.check_circle_outline
              : Icons.info_outline,
          car.vehicleAvailable ? 'Vehicle available' : 'Off the yard',
          car.vehicleAvailable ? PeachColors.success : PeachColors.warning,
        ),
        if (car.inspectionReportUrl != null)
          _Badge(Icons.assignment_outlined, 'Inspection report',
              PeachColors.primary),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Badge(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SalespersonCard extends StatelessWidget {
  final Car car;
  const _SalespersonCard({required this.car});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? PeachColors.darkCard
            : const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Talk to customer care',
              style: TextStyle(
                  fontSize: 12, color: PeachColors.grey)),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: PeachColors.primary.withOpacity(0.15),
                child: Text(
                  car.salesPerson.name.isNotEmpty
                      ? car.salesPerson.name[0].toUpperCase()
                      : 'A',
                  style: const TextStyle(
                      color: PeachColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.salesPerson.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(car.salesPerson.role,
                        style: const TextStyle(
                            color: PeachColors.grey, fontSize: 12)),
                  ],
                ),
              ),
              // Chat button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: PeachColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text('Chat',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  final Car car;
  final AppLocalizations t;
  const _SpecsGrid({required this.car, required this.t});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final specs = [
      [t.mileage, car.mileageFormatted],
      [t.fuel, car.fuelType],
      [t.transmission, car.transmission],
      [t.bodyType, car.bodyType],
      [t.drive, car.drive],
      [t.yom, '${car.year}'],
      [t.usedStatus, car.usedStatus],
      [t.color, car.color],
      [t.duty, car.dutyStatus],
      [t.seats, car.seatsMaterial],
      [t.numberOfSeats, '${car.numSeats}'],
      [t.engine, '${car.engineCc}cc'],
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.8,
      ),
      itemCount: specs.length,
      itemBuilder: (_, i) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? PeachColors.darkCard
              : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(specs[i][0],
                style: const TextStyle(
                    color: PeachColors.grey, fontSize: 10)),
            const SizedBox(height: 2),
            Text(specs[i][1],
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── Viewing request modal ─────────────────────────────────────────────────
void _showViewingModal(
    BuildContext context, WidgetRef ref, Car car, AppLocalizations t) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ViewingModal(car: car),
  );
}

class _ViewingModal extends ConsumerStatefulWidget {
  final Car car;
  const _ViewingModal({required this.car});

  @override
  ConsumerState<_ViewingModal> createState() => _ViewingModalState();
}

class _ViewingModalState extends ConsumerState<_ViewingModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _branch;
  bool _financing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final request = ViewingRequest(
      carId: widget.car.id,
      fullName: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      branch: _branch ?? '',
      interestedInFinancing: _financing,
    );
    await ref.read(viewingRequestProvider.notifier).submit(request);
    if (mounted) {
      Navigator.pop(context);
      PeachDialogs.showSuccess(
        context: context,
        title: AppLocalizations.of(context)!.success,
        message: AppLocalizations.of(context)!.viewingSubmitted,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(viewingRequestProvider);
    final locationsAsync = ref.watch(locationsProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? PeachColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: PeachColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(t.requestViewingTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            Text(
              '${widget.car.make} ${widget.car.model} ${widget.car.year}',
              style: const TextStyle(color: PeachColors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            PeachTextField(
              controller: _nameCtrl,
              label: t.fullName,
              prefixIcon: Icons.person_outline,
              validator: (v) =>
                  (v == null || v.isEmpty) ? t.fullNameRequired : null,
            ),
            const SizedBox(height: 12),
            PeachTextField(
              controller: _phoneCtrl,
              label: t.phoneNumber,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.isEmpty) ? t.phoneRequired : null,
            ),
            const SizedBox(height: 12),
            locationsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (locs) => PeachDropdown<String>(
                label: t.nearestBranch,
                value: _branch,
                items: locs,
                itemLabel: (l) => l,
                onChanged: (v) => setState(() => _branch = v),
                prefixIcon: Icons.location_on_outlined,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _financing,
                  activeColor: PeachColors.primary,
                  onChanged: (v) =>
                      setState(() => _financing = v ?? false),
                ),
                Expanded(
                  child: Text(t.interestedInFinancing,
                      style: const TextStyle(fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PeachButton(
              label: t.submit,
              isLoading: state.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}