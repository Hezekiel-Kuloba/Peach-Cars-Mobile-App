import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/preferences.dart';
import 'package:peach_cars/utilites/theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _slides = const [
    _Slide(
      icon: Icons.directions_car_rounded,
      gradient: [Color(0xFFE91E8C), Color(0xFFC2185B)],
    ),
    _Slide(
      icon: Icons.verified_rounded,
      gradient: [Color(0xFFAD1457), Color(0xFFE91E8C)],
    ),
    _Slide(
      icon: Icons.handshake_rounded,
      gradient: [Color(0xFFE91E8C), Color(0xFFFF6090)],
    ),
  ];

  Future<void> _finish() async {
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.setHasSeenOnboarding(true);
    NavigationService.pushReplacementNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titles = [t.welcome, t.slide2Title, t.slide3Title];
    final descs = [t.welcomeDesc, t.slide2Desc, t.slide3Desc];

    return Scaffold(
      body: Stack(
        children: [
          // ── PageView ────────────────────────────────────────────────
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => _SlidePage(
              slide: _slides[i],
              title: titles[i],
              desc: descs[i],
            ),
          ),

          // ── Skip button ─────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 20,
            child: TextButton(
              onPressed: _finish,
              child: Text(
                t.skip,
                style: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // ── Dots + CTA at bottom ────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  28, 24, 28, MediaQuery.of(context).padding.bottom + 24),
              decoration: BoxDecoration(
                color: isDark ? PeachColors.darkSurface : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _page == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i
                              ? PeachColors.primary
                              : PeachColors.primary.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_page < _slides.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _finish();
                        }
                      },
                      child: Text(
                        _page < _slides.length - 1 ? t.next : t.getStarted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final IconData icon;
  final List<Color> gradient;
  const _Slide({required this.icon, required this.gradient});
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  final String title;
  final String desc;

  const _SlidePage({
    required this.slide,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 60, 32, 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(slide.icon, size: 88, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
