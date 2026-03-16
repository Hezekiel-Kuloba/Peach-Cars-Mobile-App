import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/providers/car_provider.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/bottom_nav.dart';
import 'package:peach_cars/widgets/car_card.dart';
import 'package:peach_cars/widgets/common.dart';
import 'package:peach_cars/widgets/loading.dart';

class BuyCarScreen extends ConsumerStatefulWidget {
  final String? initialFilter;
  const BuyCarScreen({super.key, this.initialFilter});

  @override
  ConsumerState<BuyCarScreen> createState() => _BuyCarScreenState();
}

class _BuyCarScreenState extends ConsumerState<BuyCarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String? _selectedMake;
  int? _selectedYear;
  bool _showFilters = false;

  final _tabs = const ['All Cars', 'Fresh Imports', 'Locally Used'];
  final _tabFilters = [null, 'Fresh Import', 'Locally Used'];

  @override
  void initState() {
    super.initState();
    int initial = 0;
    if (widget.initialFilter == 'Fresh Import') initial = 1;
    if (widget.initialFilter == 'Locally Used') initial = 2;
    _tabCtrl = TabController(length: _tabs.length, vsync: this, initialIndex: initial);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) _applyFilters();
    });
  }

  void _applyFilters() {
    final filter = _tabFilters[_tabCtrl.index];
    ref.read(carsNotifierProvider.notifier).fetchCars(
          usedStatus: filter,
          make: _selectedMake,
          year: _selectedYear,
        );
  }

  void _onSearch(String q) {
    if (q.isEmpty) {
      _applyFilters();
    } else {
      ref.read(carsNotifierProvider.notifier).searchCars(q);
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final carsAsync = ref.watch(carsNotifierProvider);
    final makesAsync = ref.watch(makesProvider);

    return Scaffold(
      bottomNavigationBar: const PeachBottomNav(currentIndex: 2),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            backgroundColor:
                isDark ? PeachColors.darkSurface : Colors.white,
            elevation: 0,
            title: Text(t.buyCar,
                style: Theme.of(context).appBarTheme.titleTextStyle),
            bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(_showFilters ? 160 : 110),
              child: Column(
                children: [
                  // Search row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? PeachColors.darkCard
                                  : PeachColors.lightGrey,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const Icon(Icons.search,
                                    color: PeachColors.grey, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchCtrl,
                                    onChanged: _onSearch,
                                    decoration: InputDecoration(
                                      hintText: t.findYourDreamCar,
                                      hintStyle: const TextStyle(
                                          color: PeachColors.grey, fontSize: 13),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      filled: false,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _showFilters = !_showFilters),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _showFilters
                                  ? PeachColors.primary
                                  : PeachColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Icon(Icons.tune_rounded,
                                color: _showFilters
                                    ? Colors.white
                                    : PeachColors.primary,
                                size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Filter dropdowns
                  if (_showFilters)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        children: [
                          // Make dropdown
                          Expanded(
                            child: makesAsync.when(
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                              data: (makes) => Container(
                                height: 42,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? PeachColors.darkCard
                                      : PeachColors.lightGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedMake,
                                    hint: Text(t.make,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: PeachColors.grey)),
                                    isExpanded: true,
                                    dropdownColor: isDark
                                        ? PeachColors.darkCard
                                        : Colors.white,
                                    items: [
                                      DropdownMenuItem(
                                          value: null,
                                          child: Text(t.make,
                                              style: const TextStyle(
                                                  fontSize: 13))),
                                      ...makes.map((m) => DropdownMenuItem(
                                          value: m,
                                          child: Text(m,
                                              style: const TextStyle(
                                                  fontSize: 13)))),
                                    ],
                                    onChanged: (v) {
                                      setState(() => _selectedMake = v);
                                      _applyFilters();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Year dropdown
                          Expanded(
                            child: Container(
                              height: 42,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? PeachColors.darkCard
                                    : PeachColors.lightGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedYear,
                                  hint: Text(t.year,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: PeachColors.grey)),
                                  isExpanded: true,
                                  dropdownColor: isDark
                                      ? PeachColors.darkCard
                                      : Colors.white,
                                  items: [
                                    DropdownMenuItem(
                                        value: null,
                                        child: Text(t.year,
                                            style: const TextStyle(
                                                fontSize: 13))),
                                    ...List.generate(
                                      20,
                                      (i) => DateTime.now().year - i,
                                    ).map(
                                      (y) => DropdownMenuItem(
                                          value: y,
                                          child: Text('$y',
                                              style: const TextStyle(
                                                  fontSize: 13))),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    setState(() => _selectedYear = v);
                                    _applyFilters();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Tab bar
                  TabBar(
                    controller: _tabCtrl,
                    labelColor: PeachColors.primary,
                    unselectedLabelColor: PeachColors.grey,
                    indicatorColor: PeachColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    tabs: [
                      Tab(text: t.allCars),
                      Tab(text: t.freshImports),
                      Tab(text: t.locallyUsed),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: carsAsync.when(
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: 6,
            itemBuilder: (_, __) => const CarCardSkeleton(),
          ),
          error: (e, _) => Center(child: Text(t.somethingWentWrong)),
          data: (cars) {
            if (cars.isEmpty) {
              return PeachEmptyState(
                icon: Icons.directions_car_outlined,
                title: t.noCarsFound,
                subtitle: t.tryAdjustingFilters,
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: cars.length,
              itemBuilder: (_, i) => CarCard(car: cars[i]),
            );
          },
        ),
      ),
    );
  }
}
