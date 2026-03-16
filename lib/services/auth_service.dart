import 'package:peach_cars/constants.dart';
import 'package:peach_cars/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _client;
  static const _tokenKey = 'token';

  AuthService(this._client);

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey) ?? '';
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<User> signIn(String email, String password) async {
    final headers = await _authHeaders();
    final res = await _client.post(
      '/users/login',
      {'email': email, 'password': password},
      headers: headers,
    );
    if (res['result_code'] == 1) {
      return User.fromJson(res['user'] as Map<String, dynamic>);
    }
    throw Exception(res['message'] ?? 'Login failed');
  }

  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    final headers = await _authHeaders();
    final res = await _client.post(
      '/users/register',
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': username,
        'phone_number': phoneNumber,
        'password': password,
      },
      headers: headers,
    );
    if (res['result_code'] == 1) {
      return User.fromJson(res['user'] as Map<String, dynamic>);
    }
    throw Exception(res['message'] ?? 'Registration failed');
  }
}
