import 'package:flutter/material.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';

class PeachProcessesScreen extends StatefulWidget {
  const PeachProcessesScreen({super.key});

  @override
  State<PeachProcessesScreen> createState() => _PeachProcessesScreenState();
}

class _PeachProcessesScreenState extends State<PeachProcessesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor:
                isDark ? PeachColors.darkSurface : Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => NavigationService.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [PeachColors.primaryDark, PeachColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 52),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'peach cars',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          t.peachProcesses,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabCtrl,
              labelColor: PeachColors.primary,
              unselectedLabelColor: PeachColors.grey,
              indicatorColor: PeachColors.primary,
              indicatorWeight: 2.5,
              isScrollable: true,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                Tab(text: t.buyingACar),
                Tab(text: t.sellingACar),
                Tab(text: t.carFinancing),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _BuyingTab(),
            _SellingTab(),
            _FinancingTab(),
          ],
        ),
      ),
    );
  }
}

// ── Buying a Car ──────────────────────────────────────────────────────────
class _BuyingTab extends StatelessWidget {
  final _steps = const [
    ('Browse & Select', Icons.search_rounded,
        'Use our website or app to browse through our verified inventory. Filter by make, model, year, budget, and usage type.'),
    ('Request a Viewing', Icons.calendar_month_outlined,
        'Found something you like? Book a viewing at your nearest Peach Cars location or request a home visit.'),
    ('Inspect & Test Drive', Icons.directions_car_rounded,
        'Our team will walk you through the full inspection report and arrange a test drive for you.'),
    ('Financing Options', Icons.account_balance_outlined,
        'Explore our wide range of financing partners — banks, SACCOs, and digital lenders — to find the best payment plan for you.'),
    ('Make an Offer', Icons.handshake_rounded,
        'Happy with the car? Make an offer and our team will process your paperwork, handle the logbook transfer, and get you on the road.'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _steps.length,
      itemBuilder: (_, i) => _ProcessStep(
        step: i + 1,
        title: _steps[i].$1,
        icon: _steps[i].$2,
        description: _steps[i].$3,
        isLast: i == _steps.length - 1,
      ),
    );
  }
}

// ── Selling a Car ─────────────────────────────────────────────────────────
class _SellingTab extends StatelessWidget {
  final _steps = const [
    ('Submit Your Car', Icons.sell_outlined,
        'Fill in your car details and contact information using our simple Sell Car form. It takes less than 2 minutes.'),
    ('Valuation & Listing', Icons.price_check_rounded,
        'Our team will contact you within 24 hours to arrange a valuation and take professional photos of your car for our listings.'),
    ('We Find Buyers', Icons.people_alt_outlined,
        'We handle all enquiries, viewing requests, and negotiations on your behalf so you don\'t have to lift a finger.'),
    ('Secure Payment', Icons.verified_outlined,
        'Once a buyer is found, we handle the payment securely and ensure all funds are cleared before any handover takes place.'),
    ('Logbook Transfer', Icons.book_outlined,
        'Our team handles the full logbook transfer at NTSA, making the change of ownership seamless and stress-free.'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _steps.length,
      itemBuilder: (_, i) => _ProcessStep(
        step: i + 1,
        title: _steps[i].$1,
        icon: _steps[i].$2,
        description: _steps[i].$3,
        isLast: i == _steps.length - 1,
      ),
    );
  }
}

// ── Car Financing ─────────────────────────────────────────────────────────
class _FinancingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Flexible Financing Options',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'We work with a wide range of financing partners to help you drive home your dream car today. Choose from banks, microfinance institutions, SACCOs, and digital lenders.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(height: 1.6, color: PeachColors.grey),
        ),
        const SizedBox(height: 20),
        _FinancingCategory(
          title: 'Banks',
          partners: ['KCB Bank', 'Equity Bank', 'Absa Bank', 'Standard Chartered'],
          icon: Icons.account_balance_outlined,
          color: const Color(0xFF1565C0),
        ),
        const SizedBox(height: 12),
        _FinancingCategory(
          title: 'Microfinance & SACCOs',
          partners: ['Mwalimu SACCO', 'Stima SACCO', 'Kenya Police SACCO', 'Faulu Microfinance'],
          icon: Icons.groups_outlined,
          color: PeachColors.accent,
        ),
        const SizedBox(height: 12),
        _FinancingCategory(
          title: 'Digital Lenders',
          partners: ['Umba', 'Bees', 'Aspira', 'Timiza'],
          icon: Icons.phone_android_rounded,
          color: const Color(0xFF6A1B9A),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PeachColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: PeachColors.primary.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: PeachColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'How it Works',
                    style: TextStyle(
                        color: PeachColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...const [
                '• Select a car from our inventory',
                '• Choose your preferred financing partner',
                '• Submit your application through Peach Cars',
                '• Get pre-approved in as little as 24 hours',
                '• Drive home your car!',
              ].map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(s,
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: isDark
                                ? PeachColors.darkText
                                : PeachColors.lightText)),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _FinancingCategory extends StatelessWidget {
  final String title;
  final List<String> partners;
  final IconData icon;
  final Color color;

  const _FinancingCategory({
    required this.title,
    required this.partners,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: partners
                .map((p) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(p,
                          style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final int step;
  final String title;
  final IconData icon;
  final String description;
  final bool isLast;

  const _ProcessStep({
    required this.step,
    required this.title,
    required this.icon,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PeachColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$step',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: PeachColors.primary.withOpacity(0.25),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Container(
                padding: const EdgeInsets.all(14),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 18, color: PeachColors.primary),
                        const SizedBox(width: 8),
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark
                              ? PeachColors.darkText.withOpacity(0.7)
                              : PeachColors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
