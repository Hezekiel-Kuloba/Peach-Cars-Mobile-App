import 'package:peach_cars/constants.dart';
import 'package:peach_cars/models/car.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarService {
  final ApiClient _client;
  static const _tokenKey = 'token';

  CarService(this._client);

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey) ?? '';
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Car>> fetchAllCars({
    String? usedStatus,
    String? make,
    int? year,
    bool financingOnly = false,
  }) async {
    final res = await _client.post('/cars/all', {
      if (usedStatus != null) 'used_status': usedStatus,
      if (make != null) 'make': make,
      if (year != null) 'year': year,
      'financing_only': financingOnly,
    });
    if (res['result_code'] == 1) {
      return (res['cars'] as List<dynamic>)
          .map((j) => Car.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    throw Exception(res['message'] ?? 'Failed to fetch cars');
  }

  Future<Car> fetchOneCar(String id) async {
    final res = await _client.post('/cars/one', {'id': id});
    if (res['result_code'] == 1) {
      return Car.fromJson(res['car'] as Map<String, dynamic>);
    }
    throw Exception(res['message'] ?? 'Car not found');
  }

  Future<List<Car>> searchCars(String query) async {
    final res = await _client.post('/cars/search', {'query': query});
    if (res['result_code'] == 1) {
      return (res['cars'] as List<dynamic>)
          .map((j) => Car.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // ── Wishlist ──────────────────────────────────────────────────────────────

  Future<List<String>> getWishlistIds() async {
    final headers = await _authHeaders();
    final res = await _client.post('/wishlist/get', {}, headers: headers);
    if (res['result_code'] == 1) {
      return List<String>.from(res['ids'] as List? ?? []);
    }
    return [];
  }

  Future<List<Car>> getWishlistCars() async {
    final headers = await _authHeaders();
    final res = await _client.post('/wishlist/get', {}, headers: headers);
    if (res['result_code'] == 1) {
      return (res['cars'] as List<dynamic>)
          .map((j) => Car.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<String>> addToWishlist(String carId) async {
    final headers = await _authHeaders();
    final res =
        await _client.post('/wishlist/add', {'car_id': carId}, headers: headers);
    if (res['result_code'] == 1) {
      return List<String>.from(res['wishlist'] as List? ?? []);
    }
    throw Exception(res['message'] ?? 'Failed to add to wishlist');
  }

  Future<List<String>> removeFromWishlist(String carId) async {
    final headers = await _authHeaders();
    final res = await _client
        .post('/wishlist/remove', {'car_id': carId}, headers: headers);
    if (res['result_code'] == 1) {
      return List<String>.from(res['wishlist'] as List? ?? []);
    }
    throw Exception(res['message'] ?? 'Failed to remove from wishlist');
  }

  // ── Recently Viewed ───────────────────────────────────────────────────────

  Future<void> addToRecentlyViewed(String carId) async {
    final headers = await _authHeaders();
    await _client.post(
        '/recently_viewed/add', {'car_id': carId}, headers: headers);
  }

  Future<List<Car>> getRecentlyViewed() async {
    final headers = await _authHeaders();
    final res =
        await _client.post('/recently_viewed/get', {}, headers: headers);
    if (res['result_code'] == 1) {
      return (res['cars'] as List<dynamic>)
          .map((j) => Car.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // ── Meta ──────────────────────────────────────────────────────────────────

  Future<List<String>> getMakes() async {
    final res = await _client.post('/meta/makes', {});
    if (res['result_code'] == 1) {
      return List<String>.from(res['makes'] as List? ?? []);
    }
    return [];
  }

  Future<List<String>> getModels(String make) async {
    final res = await _client.post('/meta/models', {'make': make});
    if (res['result_code'] == 1) {
      return List<String>.from(res['models'] as List? ?? []);
    }
    return [];
  }

  Future<List<String>> getLocations() async {
    final res = await _client.post('/meta/locations', {});
    if (res['result_code'] == 1) {
      return List<String>.from(res['locations'] as List? ?? []);
    }
    return [];
  }
}
