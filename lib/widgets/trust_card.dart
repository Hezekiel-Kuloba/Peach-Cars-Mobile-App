import 'package:flutter/material.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/utilites/theme.dart';

/// The pink "Verified Cars / Clear Processes / Team Diversity" card
/// shown at the bottom of several screens on the real Peach Cars site.
class PeachTrustCard extends StatelessWidget {
  const PeachTrustCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PeachColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _item(
            icon: Icons.directions_car_rounded,
            title: t.verifiedCars,
            desc: t.verifiedCarsDesc,
          ),
          const SizedBox(height: 16),
          _item(
            icon: Icons.search_rounded,
            title: t.clearProcesses,
            desc: t.clearProcessesDesc,
          ),
          const SizedBox(height: 16),
          _item(
            icon: Icons.people_alt_rounded,
            title: t.teamDiversity,
            desc: t.teamDiversityDesc,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Small "Help and Support" card
class PeachSupportCard extends StatelessWidget {
  const PeachSupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PeachColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PeachColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.helpAndSupport,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            t.supportHours,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _pill(
                  context,
                  Icons.phone_rounded,
                  t.peachCarsPhone,
                  PeachColors.primary),
              const SizedBox(width: 8),
              _pill(
                  context,
                  Icons.chat_bubble_outline_rounded,
                  'WhatsApp',
                  PeachColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(
      BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
