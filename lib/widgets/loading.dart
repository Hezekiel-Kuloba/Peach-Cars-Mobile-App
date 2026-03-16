import 'package:flutter/material.dart';
import 'package:peach_cars/utilites/theme.dart';

class PeachLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const PeachLoader({super.key, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? PeachColors.primary,
          ),
        ),
      ),
    );
  }
}

class PeachLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const PeachLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black38,
            child: const PeachLoader(),
          ),
      ],
    );
  }
}

// ── Shimmer skeleton for car card placeholders ────────────────────────────
class CarCardSkeleton extends StatefulWidget {
  const CarCardSkeleton({super.key});

  @override
  State<CarCardSkeleton> createState() => _CarCardSkeletonState();
}

class _CarCardSkeletonState extends State<CarCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final base = isDark ? Colors.white : Colors.grey;
        final color = base.withOpacity(_anim.value);
        return Container(
          decoration: BoxDecoration(
            color: isDark ? PeachColors.darkCard : PeachColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Container(color: color),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bar(color, 0.8),
                    const SizedBox(height: 6),
                    _bar(color, 0.6),
                    const SizedBox(height: 8),
                    _bar(color, 0.4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bar(Color color, double widthFactor) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
