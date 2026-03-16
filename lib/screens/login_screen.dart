import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/providers/user_provider.dart';
import 'package:peach_cars/providers/wishlist_provider.dart';
import 'package:peach_cars/utilites/dialog.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/common.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(userProvider.notifier).signIn(
            _emailCtrl.text.trim(),
            _passCtrl.text,
          );
      await ref.read(wishlistProvider.notifier).load();
      NavigationService.pushNamedAndRemoveUntil(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        PeachDialogs.showError(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Pink hero header ──────────────────────────────────
              Container(
                width: double.infinity,
                height: size.height * 0.30,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [PeachColors.primaryDark, PeachColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(36)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo/peach_logo.jpg',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.directions_car_rounded,
                              size: 40,
                              color: PeachColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'peach cars',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),

              // ── Form ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.welcomeBack,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(t.signInToContinue,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: PeachColors.grey)),
                      const SizedBox(height: 28),
                      PeachTextField(
                        controller: _emailCtrl,
                        label: t.email,
                        hint: 'you@email.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.emailRequired;
                          if (!v.contains('@')) return t.emailInvalid;
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      PeachTextField(
                        controller: _passCtrl,
                        label: t.password,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        suffix: IconButton(
                          icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: PeachColors.grey),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.passwordRequired;
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(t.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: 8),
                      PeachButton(
                        label: t.signIn,
                        isLoading: _loading,
                        onPressed: _login,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(t.dontHaveAccount,
                              style: const TextStyle(
                                  color: PeachColors.grey)),
                          TextButton(
                            onPressed: () => NavigationService.pushNamed(
                                AppRoutes.register),
                            child: Text(t.signUp),
                          ),
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
}