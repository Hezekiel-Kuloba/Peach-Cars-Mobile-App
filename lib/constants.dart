import 'dart:convert';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// ApiClient — reads from the local db.json (no real backend yet)
// ---------------------------------------------------------------------------
class ApiClient {
  static Map<String, dynamic>? _db;

  Future<Map<String, dynamic>> _getDb() async {
    if (_db != null) return _db!;
    final raw = await rootBundle.loadString('assets/data/db.json');
    _db = json.decode(raw) as Map<String, dynamic>;
    return _db!;
  }

  /// Simulate a POST call by routing to the right handler.
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    final db = await _getDb();

    switch (endpoint) {
      // ── Auth ──────────────────────────────────────────────────────────────
      case '/users/login':
        return _login(db, body);
      case '/users/register':
        return _register(db, body);

      // ── Cars ──────────────────────────────────────────────────────────────
      case '/cars/all':
        return _carsAll(db, body);
      case '/cars/one':
        return _carsOne(db, body);
      case '/cars/search':
        return _carsSearch(db, body);

      // ── Wishlist ──────────────────────────────────────────────────────────
      case '/wishlist/add':
        return _wishlistAdd(db, body, headers);
      case '/wishlist/remove':
        return _wishlistRemove(db, body, headers);
      case '/wishlist/get':
        return _wishlistGet(db, headers);

      // ── Recently Viewed ───────────────────────────────────────────────────
      case '/recently_viewed/add':
        return _recentlyViewedAdd(db, body, headers);
      case '/recently_viewed/get':
        return _recentlyViewedGet(db, headers);

      // ── Viewing Requests ──────────────────────────────────────────────────
      case '/viewing_requests/add':
        return _viewingRequestAdd(db, body);

      // ── Sell Requests ─────────────────────────────────────────────────────
      case '/sell_requests/add':
        return _sellRequestAdd(db, body);

      // ── Referrals ─────────────────────────────────────────────────────────
      case '/referrals/add':
        return _referralAdd(db, body);

      // ── Meta ──────────────────────────────────────────────────────────────
      case '/meta/makes':
        return {'result_code': 1, 'makes': db['car_makes']};
      case '/meta/models':
        final make = body['make'] as String? ?? '';
        final models = (db['car_models'] as Map<String, dynamic>)[make] ?? [];
        return {'result_code': 1, 'models': models};
      case '/meta/locations':
        return {'result_code': 1, 'locations': db['locations']};

      default:
        return {'result_code': 0, 'message': 'Unknown endpoint: $endpoint'};
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String? _tokenToUserId(Map<String, dynamic> db, Map<String, String>? headers) {
    final auth = headers?['Authorization'] ?? '';
    if (!auth.startsWith('Bearer ')) return null;
    final token = auth.substring(7);
    final sessions = db['sessions'] as List<dynamic>;
    final session = sessions.firstWhere(
      (s) =>
          s['token'] == token &&
          s['is_active'] == true &&
          DateTime.parse(s['expires_at']).isAfter(DateTime.now()),
      orElse: () => null,
    );
    return session?['user_id'] as String?;
  }

  Map<String, dynamic>? _findUser(Map<String, dynamic> db, String userId) {
    final users = db['users'] as List<dynamic>;
    return users.firstWhere((u) => u['user_id'] == userId, orElse: () => null)
        as Map<String, dynamic>?;
  }

  // ── Auth handlers ─────────────────────────────────────────────────────────

  Map<String, dynamic> _login(Map<String, dynamic> db, Map<String, dynamic> body) {
    final email = body['email'] as String? ?? '';
    final password = body['password'] as String? ?? '';
    final users = db['users'] as List<dynamic>;
    final user = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => null,
    );
    if (user == null) {
      return {'result_code': 0, 'message': 'Invalid email or password'};
    }
    final sessions = db['sessions'] as List<dynamic>;
    final session = sessions.firstWhere(
      (s) => s['user_id'] == user['user_id'] && s['is_active'] == true,
      orElse: () => null,
    );
    final token = session?['token'] ?? 'mock_token_${user['user_id']}';
    return {
      'result_code': 1,
      'user': {...user as Map<String, dynamic>, 'token': token},
    };
  }

  Map<String, dynamic> _register(Map<String, dynamic> db, Map<String, dynamic> body) {
    final users = db['users'] as List<dynamic>;
    final exists = users.any((u) => u['email'] == body['email']);
    if (exists) {
      return {'result_code': 0, 'message': 'Email already registered'};
    }
    final newUser = {
      'user_id': 'u${DateTime.now().millisecondsSinceEpoch}',
      'first_name': body['first_name'] ?? '',
      'last_name': body['last_name'] ?? '',
      'email': body['email'] ?? '',
      'username': body['username'] ?? '',
      'phone_number': body['phone_number'] ?? '',
      'password': body['password'] ?? '',
      'email_verified': false,
      'created_at': DateTime.now().toIso8601String(),
      'wishlist': <String>[],
      'recently_viewed': <String>[],
    };
    (db['users'] as List).add(newUser);
    final token = 'mock_token_${newUser['user_id']}';
    (db['sessions'] as List).add({
      'session_id': 'sess_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': newUser['user_id'],
      'token': token,
      'is_active': true,
      'expires_at': '2030-12-31T23:59:59Z',
    });
    return {
      'result_code': 1,
      'user': {...newUser, 'token': token},
    };
  }

  // ── Car handlers ──────────────────────────────────────────────────────────

  Map<String, dynamic> _carsAll(Map<String, dynamic> db, Map<String, dynamic> body) {
    List<dynamic> cars = List.from(db['cars'] as List<dynamic>);
    final usedStatus = body['used_status'] as String?;
    final make = body['make'] as String?;
    final year = body['year'] as int?;
    final financingOnly = body['financing_only'] as bool? ?? false;

    if (usedStatus != null && usedStatus.isNotEmpty) {
      cars = cars.where((c) => c['used_status'] == usedStatus).toList();
    }
    if (make != null && make.isNotEmpty) {
      cars = cars.where((c) => c['make'] == make).toList();
    }
    if (year != null) {
      cars = cars.where((c) => c['year'] == year).toList();
    }
    if (financingOnly) {
      cars = cars.where((c) => c['financing_available'] == true).toList();
    }
    return {'result_code': 1, 'cars': cars};
  }

  Map<String, dynamic> _carsOne(Map<String, dynamic> db, Map<String, dynamic> body) {
    final id = body['id'] as String? ?? '';
    final cars = db['cars'] as List<dynamic>;
    final car = cars.firstWhere((c) => c['id'] == id, orElse: () => null);
    if (car == null) return {'result_code': 0, 'message': 'Car not found'};
    return {'result_code': 1, 'car': car};
  }

  Map<String, dynamic> _carsSearch(Map<String, dynamic> db, Map<String, dynamic> body) {
    final query = (body['query'] as String? ?? '').toLowerCase();
    final cars = db['cars'] as List<dynamic>;
    final results = cars.where((c) {
      final title = '${c['make']} ${c['model']} ${c['year']} ${c['color']}'.toLowerCase();
      return title.contains(query);
    }).toList();
    return {'result_code': 1, 'cars': results};
  }

  // ── Wishlist handlers ─────────────────────────────────────────────────────

  Map<String, dynamic> _wishlistAdd(
      Map<String, dynamic> db, Map<String, dynamic> body, Map<String, String>? headers) {
    final userId = _tokenToUserId(db, headers);
    if (userId == null) return {'result_code': 0, 'message': 'Unauthorized'};
    final user = _findUser(db, userId);
    if (user == null) return {'result_code': 0, 'message': 'User not found'};
    final carId = body['car_id'] as String? ?? '';
    final wishlist = List<String>.from(user['wishlist'] as List? ?? []);
    if (!wishlist.contains(carId)) wishlist.add(carId);
    user['wishlist'] = wishlist;
    return {'result_code': 1, 'wishlist': wishlist};
  }

  Map<String, dynamic> _wishlistRemove(
      Map<String, dynamic> db, Map<String, dynamic> body, Map<String, String>? headers) {
    final userId = _tokenToUserId(db, headers);
    if (userId == null) return {'result_code': 0, 'message': 'Unauthorized'};
    final user = _findUser(db, userId);
    if (user == null) return {'result_code': 0, 'message': 'User not found'};
    final carId = body['car_id'] as String? ?? '';
    final wishlist = List<String>.from(user['wishlist'] as List? ?? []);
    wishlist.remove(carId);
    user['wishlist'] = wishlist;
    return {'result_code': 1, 'wishlist': wishlist};
  }

  Map<String, dynamic> _wishlistGet(Map<String, dynamic> db, Map<String, String>? headers) {
    final userId = _tokenToUserId(db, headers);
    if (userId == null) return {'result_code': 0, 'message': 'Unauthorized'};
    final user = _findUser(db, userId);
    if (user == null) return {'result_code': 0, 'message': 'User not found'};
    final wishlistIds = List<String>.from(user['wishlist'] as List? ?? []);
    final cars = (db['cars'] as List<dynamic>)
        .where((c) => wishlistIds.contains(c['id']))
        .toList();
    return {'result_code': 1, 'cars': cars, 'ids': wishlistIds};
  }

  // ── Recently Viewed handlers ──────────────────────────────────────────────

  Map<String, dynamic> _recentlyViewedAdd(
      Map<String, dynamic> db, Map<String, dynamic> body, Map<String, String>? headers) {
    final userId = _tokenToUserId(db, headers);
    if (userId == null) return {'result_code': 1}; // silent if not logged in
    final user = _findUser(db, userId);
    if (user == null) return {'result_code': 1};
    final carId = body['car_id'] as String? ?? '';
    final rv = List<String>.from(user['recently_viewed'] as List? ?? []);
    rv.remove(carId);
    rv.insert(0, carId);
    if (rv.length > 10) rv.removeLast();
    user['recently_viewed'] = rv;
    return {'result_code': 1};
  }

  Map<String, dynamic> _recentlyViewedGet(
      Map<String, dynamic> db, Map<String, String>? headers) {
    final userId = _tokenToUserId(db, headers);
    if (userId == null) return {'result_code': 1, 'cars': []};
    final user = _findUser(db, userId);
    if (user == null) return {'result_code': 1, 'cars': []};
    final rvIds = List<String>.from(user['recently_viewed'] as List? ?? []);
    final cars = rvIds
        .map((id) => (db['cars'] as List<dynamic>)
            .firstWhere((c) => c['id'] == id, orElse: () => null))
        .where((c) => c != null)
        .toList();
    return {'result_code': 1, 'cars': cars};
  }

  // ── Viewing request handler ───────────────────────────────────────────────

  Map<String, dynamic> _viewingRequestAdd(
      Map<String, dynamic> db, Map<String, dynamic> body) {
    final req = {
      'id': 'vr_${DateTime.now().millisecondsSinceEpoch}',
      'car_id': body['car_id'] ?? '',
      'full_name': body['full_name'] ?? '',
      'phone_number': body['phone_number'] ?? '',
      'branch': body['branch'] ?? '',
      'interested_in_financing': body['interested_in_financing'] ?? false,
      'created_at': DateTime.now().toIso8601String(),
    };
    (db['viewing_requests'] as List).add(req);
    return {'result_code': 1, 'message': 'Viewing request submitted successfully'};
  }

  // ── Sell request handler ──────────────────────────────────────────────────

  Map<String, dynamic> _sellRequestAdd(
      Map<String, dynamic> db, Map<String, dynamic> body) {
    final req = {
      'id': 'sr_${DateTime.now().millisecondsSinceEpoch}',
      ...body,
      'created_at': DateTime.now().toIso8601String(),
    };
    (db['sell_requests'] as List).add(req);
    return {'result_code': 1, 'message': 'Sell request submitted successfully'};
  }

  // ── Referral handler ──────────────────────────────────────────────────────

  Map<String, dynamic> _referralAdd(
      Map<String, dynamic> db, Map<String, dynamic> body) {
    final ref = {
      'id': 'ref_${DateTime.now().millisecondsSinceEpoch}',
      ...body,
      'created_at': DateTime.now().toIso8601String(),
    };
    (db['referrals'] as List).add(ref);
    return {'result_code': 1, 'message': 'Referral submitted successfully'};
  }
}