import 'package:peach_cars/constants.dart';
import 'package:peach_cars/models/requests.dart';

class RequestService {
  final ApiClient _client;

  RequestService(this._client);

  Future<void> submitViewingRequest(ViewingRequest request) async {
    final res = await _client.post(
      '/viewing_requests/add',
      request.toJson(),
    );
    if (res['result_code'] != 1) {
      throw Exception(res['message'] ?? 'Failed to submit viewing request');
    }
  }

  Future<void> submitSellRequest(SellRequest request) async {
    final res = await _client.post(
      '/sell_requests/add',
      request.toJson(),
    );
    if (res['result_code'] != 1) {
      throw Exception(res['message'] ?? 'Failed to submit sell request');
    }
  }

  Future<void> submitReferral(Referral referral) async {
    final res = await _client.post(
      '/referrals/add',
      referral.toJson(),
    );
    if (res['result_code'] != 1) {
      throw Exception(res['message'] ?? 'Failed to submit referral');
    }
  }
}
