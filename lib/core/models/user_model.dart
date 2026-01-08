// class UserModel {
//   final String phone;
//   final String displayName;
//   final int experienceYears;
//   final String address;
//   final String level;
//   final ExperienceLevel experienceLevel;
//   //response
//   final String token;

//   const UserModel({
//     required this.phone,
//     required this.displayName,
//     required this.experienceYears,
//     required this.address,
//     required this.level,
//     required this.experienceLevel,
//     required this.token,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     final rawLevel = json['level']?.toString();

//     return UserModel(
//       phone: json['phone'],
//       displayName: json['displayName'],
//       experienceYears: json['experienceYears'],
//       address: json['address'],
//       level: rawLevel ?? '',
//       token: json['token'],
//       experienceLevel: ExperienceLevel.fromName(rawLevel),
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'phone': phone,
//       'displayName': displayName,
//       'experienceYears': experienceYears,
//       'address': address,
//       'level': experienceLevel.name,
//       'token': token,

//       'experienceLevel': experienceLevel,
//     };
//   }
// }

// enum ExperienceLevel {
//   fresh,
//   junior,
//   midLevel,
//   senior;

//   String get apiValue {
//     switch (this) {
//       case ExperienceLevel.fresh:
//         return 'fresh';
//       case ExperienceLevel.junior:
//         return 'junior';
//       case ExperienceLevel.midLevel:
//         return 'midLevel';
//       case ExperienceLevel.senior:
//         return 'senior';
//     }
//   }

//   String get label {
//     switch (this) {
//       case ExperienceLevel.fresh:
//         return 'Fresh';
//       case ExperienceLevel.junior:
//         return 'Junior';
//       case ExperienceLevel.midLevel:
//         return 'MidLevel';
//       case ExperienceLevel.senior:
//         return 'Senior';
//     }
//   }

//   static ExperienceLevel fromName(String? name) {
//     return ExperienceLevel.values.firstWhere(
//       (e) => e.name == name,
//       orElse: () => ExperienceLevel.fresh,
//     );
//   }
// }
