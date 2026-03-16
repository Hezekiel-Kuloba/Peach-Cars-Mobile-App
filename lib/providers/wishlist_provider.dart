import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/models/car.dart';
import 'package:peach_cars/providers/car_provider.dart';
import 'package:peach_cars/providers/user_provider.dart';
import 'package:flutter_riverpod/legacy.dart';


// ── Wishlist state notifier ───────────────────────────────────────────────
final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<Car>>((ref) {
  return WishlistNotifier(ref);
});

/// Separate provider just for the wishlist IDs (for quick isFavourite checks)
final wishlistIdsProvider = Provider<Set<String>>((ref) {
  return ref.watch(wishlistProvider).map((c) => c.id).toSet();
});

class WishlistNotifier extends StateNotifier<List<Car>> {
  final Ref _ref;

  WishlistNotifier(this._ref) : super([]) {
    load();
  }

  Future<void> load() async {
    try {
      final cars = await _ref.read(carServiceProvider).getWishlistCars();
      state = cars;
      _ref.read(userProvider.notifier).updateWishlist(cars.map((c) => c.id).toList());
    } catch (_) {}
  }

  Future<void> toggle(Car car) async {
    final ids = state.map((c) => c.id).toSet();
    try {
      if (ids.contains(car.id)) {
        final newIds =
            await _ref.read(carServiceProvider).removeFromWishlist(car.id);
        state = state.where((c) => c.id != car.id).toList();
        _ref.read(userProvider.notifier).updateWishlist(newIds);
      } else {
        final newIds =
            await _ref.read(carServiceProvider).addToWishlist(car.id);
        state = [...state, car];
        _ref.read(userProvider.notifier).updateWishlist(newIds);
      }
    } catch (_) {}
  }

  bool isFavourite(String carId) => state.any((c) => c.id == carId);
}
