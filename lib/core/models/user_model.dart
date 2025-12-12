class User {
  final String phone;
  final String displayName;
  final int experienceYears;
  final String address;
  final String level;
  final String token;
  final ExperienceLevel experienceLevel;

  User({
    required this.phone,
    required this.displayName,
    required this.experienceYears,
    required this.address,
    required this.level,
    required this.token,
    required this.experienceLevel,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final rawLevel = json['level']?.toString();

    return User(
      phone: json['phone'],
      displayName: json['displayName'],
      experienceYears: json['experienceYears'],
      address: json['address'],
      level: rawLevel ?? '',
      token: json['token'],
      experienceLevel: ExperienceLevel.fromName(rawLevel),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'displayName': displayName,
      'experienceYears': experienceYears,
      'address': address,
      'level': experienceLevel.name,
      'token': token,

      'experienceLevel': experienceLevel,
    };
  }
}

enum ExperienceLevel {
  fresh,
  junior,
  midLevel,
  senior;

  static ExperienceLevel fromName(String? name) {
    if (name == null) return ExperienceLevel.fresh;
    try {
      return ExperienceLevel.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return ExperienceLevel.fresh;
    }
  }

  String get label {
    switch (this) {
      case ExperienceLevel.fresh:
        return 'Fresh';
      case ExperienceLevel.junior:
        return 'Junior';
      case ExperienceLevel.midLevel:
        return 'MidLevel';
      case ExperienceLevel.senior:
        return 'Senior';
    }
  }
}

 
//   ExperienceLevelValues getExperienceLevelValues() {
//     switch (this) {
//       case ExperienceLevel.fresh:
//         return ExperienceLevelValues(
//           name: 'Fresh',
//           value: 'Fresh',
//           color: const Color(0xFF000000),
//         );
//       case ExperienceLevel.junior:
//         return ExperienceLevelValues(
//           name: 'Junior',
//           value: 'Junior',
//           color: const Color(0xFF000000),
//         );
//       case ExperienceLevel.midLevel:
//         return ExperienceLevelValues(
//           name: 'MidLevel',
//           value: 'MidLevel',
//           color: const Color(0xFF000000),
//         );
//       case ExperienceLevel.senior:
//         return ExperienceLevelValues(
//           name: 'Senior',
//           value: 'Senior',
//           color: const Color(0xFF000000),
//         );
//     }
//   }


// class ExperienceLevelValues {
//   final String name;
//   final String value;
//   final Color color;
//   ExperienceLevelValues({required this.name, required this.value, required this.color});
// }

// sealed class ExperienceLevelSealed {
//  final String level;
 
//  ExperienceLevelSealed({required this.level});
// }
//  class Fresh extends ExperienceLevelSealed {
// Fresh() : super(level: 'Fresh');
//   }
//   class Junior extends ExperienceLevelSealed {
// Junior() : super(level: 'Junior');
//   }
//   class MidLevel extends ExperienceLevelSealed {
// MidLevel() : super(level: 'MidLevel');
//   }
//   class Senior extends ExperienceLevelSealed {
// Senior() : super(level: 'Senior');
//   }