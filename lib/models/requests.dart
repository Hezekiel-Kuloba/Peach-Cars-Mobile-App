// ─────────────────────────────────────────────────────────────
// ViewingRequest
// ─────────────────────────────────────────────────────────────
class ViewingRequest {
  final String carId;
  final String fullName;
  final String phoneNumber;
  final String branch;
  final bool interestedInFinancing;

  ViewingRequest({
    required this.carId,
    required this.fullName,
    required this.phoneNumber,
    required this.branch,
    required this.interestedInFinancing,
  });

  Map<String, dynamic> toJson() => {
        'car_id': carId,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'branch': branch,
        'interested_in_financing': interestedInFinancing,
      };
}

// ─────────────────────────────────────────────────────────────
// SellRequest  (2-step sell form)
// ─────────────────────────────────────────────────────────────
class SellRequest {
  // Step 1 — Car Details
  final String registration;
  final String make;
  final String model;
  final int year;
  final int mileage;
  final double askingPrice;

  // Step 2 — Contact Details
  final String fullName;
  final String phoneNumber;
  final String email;
  final String location;

  SellRequest({
    required this.registration,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.askingPrice,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'registration': registration,
        'make': make,
        'model': model,
        'year': year,
        'mileage': mileage,
        'asking_price': askingPrice,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'location': location,
      };
}

// ─────────────────────────────────────────────────────────────
// Referral
// ─────────────────────────────────────────────────────────────
class Referral {
  final String yourName;
  final String yourPhone;
  final String friendName;
  final String friendPhone;
  final String friendLocation;
  final String buyingOrSelling; // 'Buying' | 'Selling' | 'Both'

  Referral({
    required this.yourName,
    required this.yourPhone,
    required this.friendName,
    required this.friendPhone,
    required this.friendLocation,
    required this.buyingOrSelling,
  });

  Map<String, dynamic> toJson() => {
        'your_name': yourName,
        'your_phone': yourPhone,
        'friend_name': friendName,
        'friend_phone': friendPhone,
        'friend_location': friendLocation,
        'buying_or_selling': buyingOrSelling,
      };
}
