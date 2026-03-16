import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/models/requests.dart';
import 'package:peach_cars/providers/car_provider.dart';
import 'package:peach_cars/providers/request_provider.dart';
import 'package:peach_cars/utilites/dialog.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/common.dart';

class ReferFriendScreen extends ConsumerStatefulWidget {
  const ReferFriendScreen({super.key});

  @override
  ConsumerState<ReferFriendScreen> createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends ConsumerState<ReferFriendScreen> {
  final _formKey = GlobalKey<FormState>();
  final _yourNameCtrl = TextEditingController();
  final _yourPhoneCtrl = TextEditingController();
  final _friendNameCtrl = TextEditingController();
  final _friendPhoneCtrl = TextEditingController();
  String? _friendLocation;
  String _buyingOrSelling = 'Buying';

  @override
  void dispose() {
    for (final c in [
      _yourNameCtrl, _yourPhoneCtrl, _friendNameCtrl, _friendPhoneCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final referral = Referral(
      yourName: _yourNameCtrl.text.trim(),
      yourPhone: _yourPhoneCtrl.text.trim(),
      friendName: _friendNameCtrl.text.trim(),
      friendPhone: _friendPhoneCtrl.text.trim(),
      friendLocation: _friendLocation ?? '',
      buyingOrSelling: _buyingOrSelling,
    );
    await ref.read(referralProvider.notifier).submit(referral);
    if (mounted) {
      await PeachDialogs.showSuccess(
        context: context,
        title: AppLocalizations.of(context)!.success,
        message: AppLocalizations.of(context)!.referralSubmitted,
        onPressed: () => NavigationService.pop(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final state = ref.watch(referralProvider);
    final locationsAsync = ref.watch(locationsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 16, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [PeachColors.primaryDark, PeachColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => NavigationService.pop(),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.referAndEarn,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.referEarnAmount,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  t.referDesc,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                      height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.people_alt_rounded,
                                color: Colors.white, size: 36),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Form ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Your details
                    Text(
                      'Your Details',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    PeachTextField(
                      controller: _yourNameCtrl,
                      label: t.yourName,
                      hint: t.yourNameHint,
                      prefixIcon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? t.fullNameRequired : null,
                    ),
                    const SizedBox(height: 14),
                    PeachTextField(
                      controller: _yourPhoneCtrl,
                      label: t.yourPhone,
                      hint: t.yourPhoneHint,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? t.phoneRequired : null,
                    ),
                    const SizedBox(height: 24),

                    // Friend details
                    Text(
                      "Friend's Details",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    PeachTextField(
                      controller: _friendNameCtrl,
                      label: t.friendName,
                      hint: t.friendNameHint,
                      prefixIcon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? t.fullNameRequired : null,
                    ),
                    const SizedBox(height: 14),
                    PeachTextField(
                      controller: _friendPhoneCtrl,
                      label: t.friendPhone,
                      hint: t.friendPhoneHint,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? t.phoneRequired : null,
                    ),
                    const SizedBox(height: 14),
                    locationsAsync.when(
                      loading: () => const SizedBox(height: 56),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (locs) => PeachDropdown<String>(
                        label: t.friendLocation,
                        value: _friendLocation,
                        items: locs,
                        itemLabel: (l) => l,
                        onChanged: (v) =>
                            setState(() => _friendLocation = v),
                        prefixIcon: Icons.location_on_outlined,
                        validator: (v) =>
                            v == null ? t.location : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Buying or selling radio
                    Text(
                      t.isFriendBuyingOrSelling,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final opt in ['Selling', 'Buying', 'Both'])
                          Expanded(
                            child: _RadioOption(
                              label: opt == 'Selling'
                                  ? t.selling
                                  : opt == 'Buying'
                                      ? t.buying
                                      : t.both,
                              selected: _buyingOrSelling == opt,
                              onTap: () =>
                                  setState(() => _buyingOrSelling = opt),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    PeachButton(
                      label: t.submit,
                      isLoading: state.isLoading,
                      onPressed: _submit,
                      icon: Icons.send_rounded,
                    ),
                    const SizedBox(height: 32),
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

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RadioOption(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? PeachColors.primary
              : PeachColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected
                  ? PeachColors.primary
                  : PeachColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 16,
              color: selected ? Colors.white : PeachColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : PeachColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
