class SalesPerson {
  final String name;
  final String role;
  final String avatar;

  SalesPerson({required this.name, required this.role, required this.avatar});

  factory SalesPerson.fromJson(Map<String, dynamic> json) {
    return SalesPerson(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
        'avatar': avatar,
      };
}

class Car {
  final String id;
  final String make;
  final String model;
  final int year;
  final String color;
  final double price;
  final int mileage;
  final int engineCc;
  final String transmission;
  final String fuelType;
  final String bodyType;
  final String drive;
  final String dutyStatus;
  final String seatsMaterial;
  final int numSeats;
  final String usedStatus;
  final bool financingAvailable;
  final bool sellerVerified;
  final bool logbookConfirmed;
  final bool vehicleAvailable;
  final String registration;
  final String location;
  final String description;
  final List<String> images;
  final SalesPerson salesPerson;
  final String? inspectionReportUrl;
  final bool isEasterDeal;
  final DateTime createdAt;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.price,
    required this.mileage,
    required this.engineCc,
    required this.transmission,
    required this.fuelType,
    required this.bodyType,
    required this.drive,
    required this.dutyStatus,
    required this.seatsMaterial,
    required this.numSeats,
    required this.usedStatus,
    required this.financingAvailable,
    required this.sellerVerified,
    required this.logbookConfirmed,
    required this.vehicleAvailable,
    required this.registration,
    required this.location,
    required this.description,
    required this.images,
    required this.salesPerson,
    this.inspectionReportUrl,
    required this.isEasterDeal,
    required this.createdAt,
  });

  String get title => '$make $model $year - $color';
  String get shortTitle => '$year $make $model';
  String get priceFormatted {
    final n = price.toInt();
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return 'Ksh ${buffer.toString()}';
  }

  String get mileageFormatted {
    final s = mileage.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return '${buffer.toString()} km';
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      mileage: json['mileage'] ?? 0,
      engineCc: json['engine_cc'] ?? 0,
      transmission: json['transmission'] ?? '',
      fuelType: json['fuel_type'] ?? '',
      bodyType: json['body_type'] ?? '',
      drive: json['drive'] ?? '',
      dutyStatus: json['duty_status'] ?? '',
      seatsMaterial: json['seats_material'] ?? '',
      numSeats: json['num_seats'] ?? 0,
      usedStatus: json['used_status'] ?? '',
      financingAvailable: json['financing_available'] ?? false,
      sellerVerified: json['seller_verified'] ?? false,
      logbookConfirmed: json['logbook_confirmed'] ?? false,
      vehicleAvailable: json['vehicle_available'] ?? true,
      registration: json['registration'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      salesPerson: json['sales_person'] != null
          ? SalesPerson.fromJson(json['sales_person'] as Map<String, dynamic>)
          : SalesPerson(name: 'Agent', role: 'Sales Person', avatar: ''),
      inspectionReportUrl: json['inspection_report_url'] as String?,
      isEasterDeal: json['is_easter_deal'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'make': make,
        'model': model,
        'year': year,
        'color': color,
        'price': price,
        'mileage': mileage,
        'engine_cc': engineCc,
        'transmission': transmission,
        'fuel_type': fuelType,
        'body_type': bodyType,
        'drive': drive,
        'duty_status': dutyStatus,
        'seats_material': seatsMaterial,
        'num_seats': numSeats,
        'used_status': usedStatus,
        'financing_available': financingAvailable,
        'seller_verified': sellerVerified,
        'logbook_confirmed': logbookConfirmed,
        'vehicle_available': vehicleAvailable,
        'registration': registration,
        'location': location,
        'description': description,
        'images': images,
        'sales_person': salesPerson.toJson(),
        'inspection_report_url': inspectionReportUrl,
        'is_easter_deal': isEasterDeal,
        'created_at': createdAt.toIso8601String(),
      };
}
