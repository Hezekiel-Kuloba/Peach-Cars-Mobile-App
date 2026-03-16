class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String phoneNumber;
  final bool emailVerified;
  final DateTime createdAt;
  final String? token;
  final List<String> wishlist;
  final List<String> recentlyViewed;

  bool get isLoggedIn => token != null && token!.isNotEmpty;
  String get fullName => '$firstName $lastName'.trim();

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.emailVerified,
    required this.createdAt,
    this.token,
    this.wishlist = const [],
    this.recentlyViewed = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      token: json['token'] as String?,
      wishlist: List<String>.from(json['wishlist'] ?? []),
      recentlyViewed: List<String>.from(json['recently_viewed'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': username,
        'phone_number': phoneNumber,
        'email_verified': emailVerified,
        'created_at': createdAt.toIso8601String(),
        'token': token,
        'wishlist': wishlist,
        'recently_viewed': recentlyViewed,
      };

  User copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? phoneNumber,
    bool? emailVerified,
    DateTime? createdAt,
    String? token,
    List<String>? wishlist,
    List<String>? recentlyViewed,
  }) {
    return User(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
      wishlist: wishlist ?? this.wishlist,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
    );
  }
}
