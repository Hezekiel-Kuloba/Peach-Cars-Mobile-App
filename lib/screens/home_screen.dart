import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/models/car.dart';
import 'package:peach_cars/providers/car_provider.dart';
import 'package:peach_cars/providers/user_provider.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/bottom_nav.dart';
import 'package:peach_cars/widgets/car_card.dart';
import 'package:peach_cars/widgets/common.dart';
import 'package:peach_cars/widgets/loading.dart';
import 'package:peach_cars/widgets/trust_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  final _heroPageCtrl = PageController();
  int _heroPage = 0;
  late TabController _tabCtrl;

  final _heroSlides = const [
    _HeroSlide(
      title: 'Get Car Financing\nHit the Road Faster',
      subtitle: 'Wide variety of cars · Thorough inspection · Car for every budget',
      bg1: Color(0xFF26A69A),
      bg2: Color(0xFF4DB6AC),
      cta1: 'Get Financing',
      cta2: 'See Easter Deals',
    ),
    _HeroSlide(
      title: 'Find Your\nDream Car Today',
      subtitle: 'Over 200+ verified cars · Flexible payment · Transparent process',
      bg1: Color(0xFFE91E8C),
      bg2: Color(0xFFC2185B),
      cta1: 'Browse Cars',
      cta2: 'Fresh Imports',
    ),
    _HeroSlide(
      title: 'Sell Your Car\nHassle-Free',
      subtitle: 'We handle viewings · Secure payments · Logbook transfers',
      bg1: Color(0xFF8E24AA),
      bg2: Color(0xFFE91E8C),
      cta1: 'Sell My Car',
      cta2: 'Learn More',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        final filters = [null, 'Fresh Import', 'Locally Used'];
        ref.read(carsNotifierProvider.notifier).fetchCars(
              usedStatus: filters[_tabCtrl.index],
            );
      }
    });
    // Auto-advance hero
    Future.delayed(const Duration(seconds: 4), _autoAdvance);
  }

  void _autoAdvance() {
    if (!mounted) return;
    final next = (_heroPage + 1) % _heroSlides.length;
    _heroPageCtrl.animateToPage(next,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 4), _autoAdvance);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _heroPageCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final carsAsync = ref.watch(carsNotifierProvider);
    final recentlyViewed = ref.watch(recentlyViewedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final makesAsync = ref.watch(makesProvider);

    return Scaffold(
      backgroundColor:
          isDark ? PeachColors.darkBg : const Color(0xFFFDF5F8),
      bottomNavigationBar: const PeachBottomNav(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          // ── Top bar (call + user) ─────────────────────────────
          SliverToBoxAdapter(
            child: _TopBar(user: user, t: t),
          ),

          // ── Logo header ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Logo image — fallback to icon if not loaded
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Image.asset(
                      'assets/images/logo/peach_logo.jpg',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                            color: PeachColors.primary,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.directions_car,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'peach cars',
                    style: TextStyle(
                      color: isDark
                          ? PeachColors.darkText
                          : PeachColors.lightText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.favorite_border,
                        color: isDark
                            ? PeachColors.darkText
                            : PeachColors.lightText),
                    onPressed: () => NavigationService.pushNamed(AppRoutes.wishlist),
                  ),
                  IconButton(
                    icon: Icon(Icons.person_outline_rounded,
                        color: isDark
                            ? PeachColors.darkText
                            : PeachColors.lightText),
                    onPressed: () =>
                        NavigationService.pushNamed(AppRoutes.profile),
                  ),
                ],
              ),
            ),
          ),

          // ── Hero Slider ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _HeroSlider(
                slides: _heroSlides,
                controller: _heroPageCtrl,
                currentPage: _heroPage,
                onPageChanged: (i) => setState(() => _heroPage = i),
              ),
            ),
          ),

          // ── Search + filter section ───────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? PeachColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? PeachColors.darkCard
                          : PeachColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        const Icon(Icons.search, color: PeachColors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: t.findYourDreamCar,
                              hintStyle: const TextStyle(
                                  color: PeachColors.grey, fontSize: 14),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (q) => NavigationService.pushNamed(
                                AppRoutes.buyCar, arguments: q),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => NavigationService.pushNamed(
                              AppRoutes.buyCar,
                              arguments: _searchCtrl.text),
                          child: Container(
                            width: 44,
                            height: 44,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: PeachColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.search,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter chips row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          icon: Icons.grid_view_outlined,
                          label: t.make,
                          onTap: () =>
                              NavigationService.pushNamed(AppRoutes.buyCar),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          icon: Icons.calendar_today_outlined,
                          label: t.year,
                          onTap: () =>
                              NavigationService.pushNamed(AppRoutes.buyCar),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          icon: Icons.thumb_up_outlined,
                          label: t.easterDeals,
                          onTap: () =>
                              NavigationService.pushNamed(AppRoutes.buyCar),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          icon: Icons.account_balance_outlined,
                          label: t.financingAvailable,
                          onTap: () =>
                              NavigationService.pushNamed(AppRoutes.buyCar),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Car listing tabs ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  _TabPill(
                    label: t.allCars,
                    selected: _tabCtrl.index == 0,
                    onTap: () {
                      _tabCtrl.animateTo(0);
                      setState(() {});
                      ref
                          .read(carsNotifierProvider.notifier)
                          .fetchCars();
                    },
                  ),
                  const SizedBox(width: 8),
                  _TabPill(
                    label: t.freshImports,
                    selected: _tabCtrl.index == 1,
                    onTap: () {
                      _tabCtrl.animateTo(1);
                      setState(() {});
                      ref
                          .read(carsNotifierProvider.notifier)
                          .fetchCars(usedStatus: 'Fresh Import');
                    },
                  ),
                  const SizedBox(width: 8),
                  _TabPill(
                    label: 'Locally Used',
                    selected: _tabCtrl.index == 2,
                    onTap: () {
                      _tabCtrl.animateTo(2);
                      setState(() {});
                      ref
                          .read(carsNotifierProvider.notifier)
                          .fetchCars(usedStatus: 'Locally Used');
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Car grid ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: carsAsync.when(
              loading: () => SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, __) => const CarCardSkeleton(),
                  childCount: 6,
                ),
              ),
              error: (_, __) => SliverToBoxAdapter(
                  child: Center(child: Text(t.somethingWentWrong))),
              data: (cars) => SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => CarCard(car: cars[i]),
                  childCount: cars.take(6).length,
                ),
              ),
            ),
          ),

          // See all cars button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: OutlinedButton(
                onPressed: () =>
                    NavigationService.pushNamed(AppRoutes.buyCar),
                child: Text(t.allCars),
              ),
            ),
          ),

          // ── Recently viewed ───────────────────────────────────
          if (recentlyViewed.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: SectionHeader(
                    title: t.recentlyViewedCars),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 230,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: recentlyViewed.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => SizedBox(
                      width: 165, child: CarCard(car: recentlyViewed[i])),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],

          // ── Trust card ────────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PeachTrustCard(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Support card ──────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PeachSupportCard(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Footer: Our Locations ─────────────────────────────
          const SliverToBoxAdapter(child: _LocationsFooter()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Footer: Newsletter ────────────────────────────────
          const SliverToBoxAdapter(child: _NewsletterSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final dynamic user;
  final AppLocalizations t;
  const _TopBar({required this.user, required this.t});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.grey.withOpacity(0.07),
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 4, 16, 6),
      child: Row(
        children: [
          const Icon(Icons.phone, size: 13, color: PeachColors.grey),
          const SizedBox(width: 4),
          const Text('Call: 0709 726900',
              style: TextStyle(fontSize: 12, color: PeachColors.grey)),
          const SizedBox(width: 12),
          Container(width: 1, height: 12, color: PeachColors.grey),
          const SizedBox(width: 12),
          const Icon(Icons.person_outline, size: 13, color: PeachColors.grey),
          const SizedBox(width: 4),
          Text(
            user?.firstName ?? 'Guest',
            style: const TextStyle(
                fontSize: 12,
                color: PeachColors.primary,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── Hero Slider ───────────────────────────────────────────────────────────
class _HeroSlide {
  final String title;
  final String subtitle;
  final Color bg1;
  final Color bg2;
  final String cta1;
  final String cta2;
  const _HeroSlide({
    required this.title,
    required this.subtitle,
    required this.bg1,
    required this.bg2,
    required this.cta1,
    required this.cta2,
  });
}

class _HeroSlider extends StatelessWidget {
  final List<_HeroSlide> slides;
  final PageController controller;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _HeroSlider({
    required this.slides,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: slides.length,
              onPageChanged: onPageChanged,
              itemBuilder: (_, i) => _HeroSlideCard(slide: slides[i]),
            ),
            // Left arrow
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    final prev =
                        (currentPage - 1 + slides.length) % slides.length;
                    controller.animateToPage(prev,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.chevron_left,
                        size: 18, color: Colors.black54),
                  ),
                ),
              ),
            ),
            // Right arrow
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    final next = (currentPage + 1) % slides.length;
                    controller.animateToPage(next,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.chevron_right,
                        size: 18, color: Colors.black54),
                  ),
                ),
              ),
            ),
            // Dots
            Positioned(
              bottom: 10,
              right: 16,
              child: Row(
                children: List.generate(
                  slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: currentPage == i ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: currentPage == i
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSlideCard extends StatelessWidget {
  final _HeroSlide slide;
  const _HeroSlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [slide.bg1, slide.bg2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 80, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slide.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () =>
                      NavigationService.pushNamed(AppRoutes.peachProcesses),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: slide.bg1,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.6)),
                    ),
                    child: Text(
                      slide.cta1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                  onTap: () =>
                      NavigationService.pushNamed(AppRoutes.buyCar),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: PeachColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      slide.cta2,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            slide.subtitle,
            style: TextStyle(
                color: Colors.white.withOpacity(0.85), fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? PeachColors.darkCard : PeachColors.lightGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark
                  ? Colors.white12
                  : Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: PeachColors.grey),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: PeachColors.grey,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ── Tab pill ──────────────────────────────────────────────────────────────
class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabPill(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? PeachColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: selected
                  ? PeachColors.primary
                  : Colors.grey.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : PeachColors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Locations footer ──────────────────────────────────────────────────────
class _LocationsFooter extends StatelessWidget {
  const _LocationsFooter();

  static const _locations = [
    _BranchInfo(
        name: 'Peach Cars — Lavington',
        street: 'James Gichuru Road',
        area: 'Lavington, Nairobi'),
    _BranchInfo(
        name: 'Peach Cars — Windsor',
        street: 'Northern Bypass',
        area: 'Windsor, Off Kiambu Road'),
    _BranchInfo(
        name: "Peach Cars — Lang'ata",
        street: 'Next to House of Grace',
        area: "Lang'ata, Nairobi"),
    _BranchInfo(
        name: 'Peach Cars — Kamakis',
        street: 'Next to Shell Kamakis',
        area: 'Kamakis, Nairobi'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? PeachColors.darkCard
            : const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Locations',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          ..._locations.map(
            (loc) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  if (loc.street.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(loc.street,
                        style: const TextStyle(
                            fontSize: 13, color: PeachColors.grey)),
                  ],
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: PeachColors.primary),
                      const SizedBox(width: 4),
                      Text(loc.area,
                          style: const TextStyle(
                              fontSize: 13, color: PeachColors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.work_outline,
                  size: 16, color: PeachColors.primary),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Work With Us',
                  style: TextStyle(
                      color: PeachColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchInfo {
  final String name;
  final String street;
  final String area;
  const _BranchInfo(
      {required this.name, required this.street, required this.area});
}

// ── Newsletter section ─────────────────────────────────────────────────────
class _NewsletterSection extends StatefulWidget {
  const _NewsletterSection();

  @override
  State<_NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends State<_NewsletterSection> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? PeachColors.darkCard
            : const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peach Newsletter',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign up for our newsletter to get updates straight into your inbox.',
            style: TextStyle(
                fontSize: 13, color: PeachColors.grey, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Full Name field (white card style like design)
          Container(
            decoration: BoxDecoration(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Full Name...',
                hintStyle:
                    TextStyle(color: PeachColors.grey, fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? PeachColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter Email...',
                hintStyle:
                    TextStyle(color: PeachColors.grey, fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for subscribing!'),
                    backgroundColor: PeachColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _nameCtrl.clear();
                _emailCtrl.clear();
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}