import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/constants.dart';
import 'package:peach_cars/models/requests.dart';
import 'package:peach_cars/services/request_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final requestServiceProvider = Provider<RequestService>((ref) {
  return RequestService(ApiClient());
});

// ── Loading state wrapper ─────────────────────────────────────────────────
class RequestState {
  final bool isLoading;
  final String? error;
  final bool success;

  const RequestState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });
}

// ── Viewing request notifier ──────────────────────────────────────────────
final viewingRequestProvider =
    StateNotifierProvider<ViewingRequestNotifier, RequestState>((ref) {
  return ViewingRequestNotifier(ref.read(requestServiceProvider));
});

class ViewingRequestNotifier extends StateNotifier<RequestState> {
  final RequestService _service;
  ViewingRequestNotifier(this._service) : super(const RequestState());

  Future<void> submit(ViewingRequest request) async {
    state = const RequestState(isLoading: true);
    try {
      await _service.submitViewingRequest(request);
      state = const RequestState(success: true);
    } catch (e) {
      state = RequestState(error: e.toString());
    }
  }

  void reset() => state = const RequestState();
}

// ── Sell request notifier ─────────────────────────────────────────────────
final sellRequestProvider =
    StateNotifierProvider<SellRequestNotifier, RequestState>((ref) {
  return SellRequestNotifier(ref.read(requestServiceProvider));
});

class SellRequestNotifier extends StateNotifier<RequestState> {
  final RequestService _service;
  SellRequestNotifier(this._service) : super(const RequestState());

  Future<void> submit(SellRequest request) async {
    state = const RequestState(isLoading: true);
    try {
      await _service.submitSellRequest(request);
      state = const RequestState(success: true);
    } catch (e) {
      state = RequestState(error: e.toString());
    }
  }

  void reset() => state = const RequestState();
}

// ── Referral notifier ─────────────────────────────────────────────────────
final referralProvider =
    StateNotifierProvider<ReferralNotifier, RequestState>((ref) {
  return ReferralNotifier(ref.read(requestServiceProvider));
});

class ReferralNotifier extends StateNotifier<RequestState> {
  final RequestService _service;
  ReferralNotifier(this._service) : super(const RequestState());

  Future<void> submit(Referral referral) async {
    state = const RequestState(isLoading: true);
    try {
      await _service.submitReferral(referral);
      state = const RequestState(success: true);
    } catch (e) {
      state = RequestState(error: e.toString());
    }
  }

  void reset() => state = const RequestState();
}
