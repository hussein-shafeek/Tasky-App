class User {
  final String phone;
  final String displayName;
  final int experienceYears;
  final String address;
  final String level;
  final String token;

  User({
    required this.phone,
    required this.displayName,
    required this.experienceYears,
    required this.address,
    required this.level,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phone: json['phone'],
      displayName: json['displayName'],
      experienceYears: json['experienceYears'],
      address: json['address'],
      level: json['level'],
      token: json['token'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'displayName': displayName,
      'experienceYears': experienceYears,
      'address': address,
      'level': level,
      'token': token,
    };
  }
}
