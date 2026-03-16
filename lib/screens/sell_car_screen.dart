import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/models/requests.dart';
import 'package:peach_cars/providers/car_provider.dart';
import 'package:peach_cars/providers/request_provider.dart';
import 'package:peach_cars/utilites/dialog.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/bottom_nav.dart';
import 'package:peach_cars/widgets/common.dart';

class SellCarScreen extends ConsumerStatefulWidget {
  const SellCarScreen({super.key});

  @override
  ConsumerState<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends ConsumerState<SellCarScreen> {
  int _step = 0;
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  // Step 1
  final _regCtrl = TextEditingController();
  String? _make;
  String? _model;
  int? _year;
  final _mileageCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  // Step 2
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String? _location;
  bool _acceptTerms = false;

  @override
  void dispose() {
    for (final c in [
      _regCtrl, _mileageCtrl, _priceCtrl, _nameCtrl, _phoneCtrl, _emailCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_step2Key.currentState!.validate()) return;
    if (!_acceptTerms) {
      PeachDialogs.showError(
        context: context,
        title: AppLocalizations.of(context)!.error,
        message: AppLocalizations.of(context)!.termsRequired,
      );
      return;
    }
    final request = SellRequest(
      registration: _regCtrl.text.trim(),
      make: _make ?? '',
      model: _model ?? '',
      year: _year ?? 0,
      mileage: int.tryParse(_mileageCtrl.text.replaceAll(',', '')) ?? 0,
      askingPrice:
          double.tryParse(_priceCtrl.text.replaceAll(',', '')) ?? 0,
      fullName: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      location: _location ?? '',
    );
    await ref.read(sellRequestProvider.notifier).submit(request);
    if (mounted) {
      await PeachDialogs.showSuccess(
        context: context,
        title: AppLocalizations.of(context)!.success,
        message: AppLocalizations.of(context)!.sellRequestSubmitted,
        onPressed: () => NavigationService.pushReplacementNamed(AppRoutes.home),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(sellRequestProvider);

    return Scaffold(
      bottomNavigationBar: const PeachBottomNav(currentIndex: 3),
      body: CustomScrollView(
        slivers: [
          // ── Hero header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 16, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [PeachColors.primaryDark, PeachColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'peach cars',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.sellYourCar,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.sellYourCarDesc,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Step indicator
                  StepIndicator(
                    totalSteps: 2,
                    currentStep: _step,
                    labels: [t.carDetails, t.contactDetails],
                    subLabels: [t.aboutYourCar, t.howToReachYou],
                  ),
                  const SizedBox(height: 28),

                  // Step forms
                  if (_step == 0) _Step1(
                    formKey: _step1Key,
                    regCtrl: _regCtrl,
                    mileageCtrl: _mileageCtrl,
                    priceCtrl: _priceCtrl,
                    make: _make,
                    model: _model,
                    year: _year,
                    onMakeChanged: (v) => setState(() {
                      _make = v;
                      _model = null;
                    }),
                    onModelChanged: (v) => setState(() => _model = v),
                    onYearChanged: (v) => setState(() => _year = v),
                    onNext: () {
                      if (_step1Key.currentState!.validate()) {
                        setState(() => _step = 1);
                      }
                    },
                  )
                  else _Step2(
                    formKey: _step2Key,
                    nameCtrl: _nameCtrl,
                    phoneCtrl: _phoneCtrl,
                    emailCtrl: _emailCtrl,
                    location: _location,
                    acceptTerms: _acceptTerms,
                    onLocationChanged: (v) => setState(() => _location = v),
                    onTermsChanged: (v) =>
                        setState(() => _acceptTerms = v ?? false),
                    onBack: () => setState(() => _step = 0),
                    onSubmit: _submit,
                    isLoading: state.isLoading,
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

// ── Step 1: Car Details ───────────────────────────────────────────────────
class _Step1 extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController regCtrl, mileageCtrl, priceCtrl;
  final String? make, model;
  final int? year;
  final ValueChanged<String?> onMakeChanged, onModelChanged;
  final ValueChanged<int?> onYearChanged;
  final VoidCallback onNext;

  const _Step1({
    required this.formKey,
    required this.regCtrl,
    required this.mileageCtrl,
    required this.priceCtrl,
    required this.make,
    required this.model,
    required this.year,
    required this.onMakeChanged,
    required this.onModelChanged,
    required this.onYearChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final makesAsync = ref.watch(makesProvider);
    final modelsAsync = make != null
        ? ref.watch(modelsProvider(make!))
        : const AsyncValue<List<String>>.data([]);

    return Form(
      key: formKey,
      child: Column(
        children: [
          PeachTextField(
            controller: regCtrl,
            label: t.carRegistration,
            hint: t.carRegistrationHint,
            prefixIcon: Icons.confirmation_number_outlined,
            validator: (v) =>
                (v == null || v.isEmpty) ? t.carRegistration : null,
          ),
          const SizedBox(height: 14),
          // Make
          makesAsync.when(
            loading: () => const SizedBox(height: 56),
            error: (_, __) => const SizedBox.shrink(),
            data: (makes) => PeachDropdown<String>(
              label: t.make,
              value: make,
              items: makes,
              itemLabel: (m) => m,
              onChanged: onMakeChanged,
              prefixIcon: Icons.branding_watermark_outlined,
              validator: (v) => v == null ? t.make : null,
            ),
          ),
          const SizedBox(height: 14),
          // Model
          modelsAsync.when(
            loading: () => const SizedBox(height: 56),
            error: (_, __) => const SizedBox.shrink(),
            data: (models) => PeachDropdown<String>(
              label: t.model,
              value: model,
              items: models,
              itemLabel: (m) => m,
              onChanged: onModelChanged,
              enabled: make != null,
              prefixIcon: Icons.directions_car_outlined,
              validator: (v) => v == null ? t.model : null,
            ),
          ),
          const SizedBox(height: 14),
          // Year
          PeachDropdown<int>(
            label: t.year,
            value: year,
            items: List.generate(
                20, (i) => DateTime.now().year - i),
            itemLabel: (y) => '$y',
            onChanged: onYearChanged,
            prefixIcon: Icons.calendar_today_outlined,
            validator: (v) => v == null ? t.year : null,
          ),
          const SizedBox(height: 14),
          PeachTextField(
            controller: mileageCtrl,
            label: t.mileage,
            hint: t.enterMileage,
            prefixIcon: Icons.speed_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) =>
                (v == null || v.isEmpty) ? t.mileage : null,
          ),
          const SizedBox(height: 14),
          PeachTextField(
            controller: priceCtrl,
            label: t.askingPrice,
            hint: t.enterAskingPrice,
            prefixIcon: Icons.attach_money_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) =>
                (v == null || v.isEmpty) ? t.askingPrice : null,
          ),
          const SizedBox(height: 28),
          PeachButton(label: t.next, onPressed: onNext),
        ],
      ),
    );
  }
}

// ── Step 2: Contact Details ───────────────────────────────────────────────
class _Step2 extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, phoneCtrl, emailCtrl;
  final String? location;
  final bool acceptTerms;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onBack, onSubmit;
  final bool isLoading;

  const _Step2({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.location,
    required this.acceptTerms,
    required this.onLocationChanged,
    required this.onTermsChanged,
    required this.onBack,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final locationsAsync = ref.watch(locationsProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          PeachTextField(
            controller: nameCtrl,
            label: t.fullName,
            prefixIcon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.isEmpty) ? t.fullNameRequired : null,
          ),
          const SizedBox(height: 14),
          PeachTextField(
            controller: phoneCtrl,
            label: t.phoneNumber,
            hint: '+254 7XX XXX XXX',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.isEmpty) return t.phoneRequired;
              if (v.length < 10) return t.phoneInvalid;
              return null;
            },
          ),
          const SizedBox(height: 14),
          PeachTextField(
            controller: emailCtrl,
            label: t.emailAddress,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return t.emailRequired;
              if (!v.contains('@')) return t.emailInvalid;
              return null;
            },
          ),
          const SizedBox(height: 14),
          locationsAsync.when(
            loading: () => const SizedBox(height: 56),
            error: (_, __) => const SizedBox.shrink(),
            data: (locs) => PeachDropdown<String>(
              label: t.location,
              value: location,
              items: locs,
              itemLabel: (l) => l,
              onChanged: onLocationChanged,
              prefixIcon: Icons.location_on_outlined,
              validator: (v) => v == null ? t.location : null,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: acceptTerms,
                activeColor: PeachColors.primary,
                onChanged: onTermsChanged,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(t.confirmTerms,
                      style: const TextStyle(fontSize: 12, height: 1.4)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PeachButton(
                    label: t.back, outlined: true, onPressed: onBack),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PeachButton(
                    label: t.submit,
                    isLoading: isLoading,
                    onPressed: onSubmit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
