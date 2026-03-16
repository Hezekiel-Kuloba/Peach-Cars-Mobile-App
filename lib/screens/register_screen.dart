import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:peach_cars/providers/user_provider.dart';
import 'package:peach_cars/utilites/dialog.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';
import 'package:peach_cars/widgets/common.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [
      _firstCtrl, _lastCtrl, _emailCtrl, _userCtrl,
      _phoneCtrl, _passCtrl, _confirmCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      PeachDialogs.showError(
        context: context,
        title: AppLocalizations.of(context)!.error,
        message: AppLocalizations.of(context)!.termsRequired,
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(userProvider.notifier).signUp(
            firstName: _firstCtrl.text.trim(),
            lastName: _lastCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            username: _userCtrl.text.trim(),
            phoneNumber: _phoneCtrl.text.trim(),
            password: _passCtrl.text,
          );
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [PeachColors.primaryDark, PeachColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () => NavigationService.pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.createAccount,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        Text(
                          'Join Peach Cars today',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Form ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PeachTextField(
                              controller: _firstCtrl,
                              label: t.firstName,
                              prefixIcon: Icons.person_outline,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? t.firstNameRequired
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PeachTextField(
                              controller: _lastCtrl,
                              label: t.lastName,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? t.lastNameRequired
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
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
                        controller: _userCtrl,
                        label: t.username,
                        prefixIcon: Icons.alternate_email_rounded,
                        validator: (v) => (v == null || v.isEmpty)
                            ? t.usernameRequired
                            : null,
                      ),
                      const SizedBox(height: 14),
                      PeachTextField(
                        controller: _phoneCtrl,
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
                        controller: _passCtrl,
                        label: t.password,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePass,
                        suffix: IconButton(
                          icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: PeachColors.grey, size: 20),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.passwordRequired;
                          if (v.length < 8) return t.passwordMinLength;
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      PeachTextField(
                        controller: _confirmCtrl,
                        label: t.confirmPassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        suffix: IconButton(
                          icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: PeachColors.grey, size: 20),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        validator: (v) {
                          if (v != _passCtrl.text) return t.passwordsDontMatch;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Terms checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: PeachColors.primary,
                            onChanged: (v) =>
                                setState(() => _acceptTerms = v ?? false),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(t.termsAccept,
                                  style: const TextStyle(fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PeachButton(
                        label: t.signUp,
                        isLoading: _loading,
                        onPressed: _register,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(t.alreadyHaveAccount,
                              style:
                                  const TextStyle(color: PeachColors.grey)),
                          TextButton(
                            onPressed: () => NavigationService.pop(),
                            child: Text(t.signIn),
                          ),
                        ],
                      ),
                    ],
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
