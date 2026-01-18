class ProfileModel {
  final String id;
  final String phone;
  final String displayName;
  final int experienceYears;
  final String address;
  final String level;

  ProfileModel({
    required this.id,
    required this.phone,
    required this.displayName,
    required this.experienceYears,
    required this.address,
    required this.level,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      phone: json['username'],
      displayName: json['displayName'],
      experienceYears: json['experienceYears'],
      address: json['address'],
      level: json['level'],
    );
  }
}
