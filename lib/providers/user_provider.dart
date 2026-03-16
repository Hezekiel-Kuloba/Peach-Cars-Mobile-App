import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:peach_cars/constants.dart';
import 'package:peach_cars/models/user.dart';
import 'package:peach_cars/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ApiClient());
});

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier(ref.read(authServiceProvider));
});

class UserNotifier extends StateNotifier<User?> {
  final AuthService _authService;

  UserNotifier(this._authService) : super(null) {
    checkLoginStatus();
  }

  Future<void> signIn(String email, String password) async {
    final user = await _authService.signIn(email, password);
    state = user;
    await _saveToken(user.token!);
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    final user = await _authService.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      password: password,
    );
    state = user;
    if (user.token != null) await _saveToken(user.token!);
  }

  Future<void> logout() async {
    await _clearToken();
    state = null;
  }

  /// Update wishlist ids on user state (called by wishlist provider)
  void updateWishlist(List<String> ids) {
    if (state == null) return;
    state = state!.copyWith(wishlist: ids);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return false;

    try {
      final raw = await rootBundle.loadString('assets/data/db.json');
      final db = json.decode(raw) as Map<String, dynamic>;
      final sessions = db['sessions'] as List<dynamic>;
      final session = sessions.firstWhere(
        (s) =>
            s['token'] == token &&
            s['is_active'] == true &&
            DateTime.parse(s['expires_at']).isAfter(DateTime.now()),
        orElse: () => null,
      );
      if (session == null) {
        await _clearToken();
        return false;
      }
      final users = db['users'] as List<dynamic>;
      final userJson = users.firstWhere(
        (u) => u['user_id'] == session['user_id'],
        orElse: () => null,
      ) as Map<String, dynamic>?;

      if (userJson != null) {
        state = User.fromJson({...userJson, 'token': token});
        return true;
      }
    } catch (_) {}
    await _clearToken();
    return false;
  }
}
