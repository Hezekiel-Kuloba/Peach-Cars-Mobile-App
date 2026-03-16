import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/constants.dart';
import 'package:peach_cars/models/car.dart';
import 'package:peach_cars/services/car_service.dart';
import 'package:flutter_riverpod/legacy.dart';

// ── Service provider ──────────────────────────────────────────────────────
final carServiceProvider = Provider<CarService>((ref) {
  return CarService(ApiClient());
});

// ── Filter state ──────────────────────────────────────────────────────────
class CarFilter {
  final String? usedStatus; // null = All, 'Fresh Import', 'Locally Used'
  final String? make;
  final int? year;
  final bool financingOnly;
  final String searchQuery;

  const CarFilter({
    this.usedStatus,
    this.make,
    this.year,
    this.financingOnly = false,
    this.searchQuery = '',
  });

  CarFilter copyWith({
    Object? usedStatus = _sentinel,
    Object? make = _sentinel,
    Object? year = _sentinel,
    bool? financingOnly,
    String? searchQuery,
  }) {
    return CarFilter(
      usedStatus: usedStatus == _sentinel ? this.usedStatus : usedStatus as String?,
      make: make == _sentinel ? this.make : make as String?,
      year: year == _sentinel ? this.year : year as int?,
      financingOnly: financingOnly ?? this.financingOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

const _sentinel = Object();

final carFilterProvider = StateProvider<CarFilter>((ref) => const CarFilter());

// ── All cars notifier ─────────────────────────────────────────────────────
final carsNotifierProvider =
    StateNotifierProvider<CarsNotifier, AsyncValue<List<Car>>>((ref) {
  return CarsNotifier(ref.read(carServiceProvider));
});

class CarsNotifier extends StateNotifier<AsyncValue<List<Car>>> {
  final CarService _service;

  CarsNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchCars();
  }

  Future<void> fetchCars({
    String? usedStatus,
    String? make,
    int? year,
    bool financingOnly = false,
  }) async {
    state = const AsyncValue.loading();
    try {
      final cars = await _service.fetchAllCars(
        usedStatus: usedStatus,
        make: make,
        year: year,
        financingOnly: financingOnly,
      );
      state = AsyncValue.data(cars);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> searchCars(String query) async {
    if (query.isEmpty) {
      await fetchCars();
      return;
    }
    state = const AsyncValue.loading();
    try {
      final cars = await _service.searchCars(query);
      state = AsyncValue.data(cars);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ── Single car provider ───────────────────────────────────────────────────
final carDetailProvider =
    FutureProvider.family<Car, String>((ref, id) async {
  return ref.read(carServiceProvider).fetchOneCar(id);
});

// ── Makes provider ────────────────────────────────────────────────────────
final makesProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(carServiceProvider).getMakes();
});

// ── Models provider (depends on selected make) ────────────────────────────
final modelsProvider = FutureProvider.family<List<String>, String>((ref, make) async {
  if (make.isEmpty) return [];
  return ref.read(carServiceProvider).getModels(make);
});

// ── Locations provider ────────────────────────────────────────────────────
final locationsProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(carServiceProvider).getLocations();
});

// ── Recently viewed provider ──────────────────────────────────────────────
final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<Car>>((ref) {
  return RecentlyViewedNotifier(ref.read(carServiceProvider));
});

class RecentlyViewedNotifier extends StateNotifier<List<Car>> {
  final CarService _service;

  RecentlyViewedNotifier(this._service) : super([]) {
    load();
  }

  Future<void> load() async {
    try {
      final cars = await _service.getRecentlyViewed();
      state = cars;
    } catch (_) {}
  }

  Future<void> addCar(String carId) async {
    try {
      await _service.addToRecentlyViewed(carId);
      await load();
    } catch (_) {}
  }
}
