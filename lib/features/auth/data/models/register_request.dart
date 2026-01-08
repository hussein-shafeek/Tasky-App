class RegisterRequest {
  final String phone;
  final String password;
  final String displayName;
  final int experienceYears;
  final String address;
  final ExperienceLevel experienceLevel;

  const RegisterRequest({
    required this.phone,
    required this.password,
    required this.displayName,
    required this.experienceYears,
    required this.address,
    required this.experienceLevel,
  });
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
      'displayName': displayName,
      'experienceYears': experienceYears,
      'address': address,
      'level': experienceLevel.apiValue,
    };
  }
}

enum ExperienceLevel {
  fresh,
  junior,
  midLevel,
  senior;

  String get apiValue {
    switch (this) {
      case ExperienceLevel.fresh:
        return 'fresh';
      case ExperienceLevel.junior:
        return 'junior';
      case ExperienceLevel.midLevel:
        return 'midLevel';
      case ExperienceLevel.senior:
        return 'senior';
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

  static ExperienceLevel fromName(String? name) {
    return ExperienceLevel.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ExperienceLevel.fresh,
    );
  }
}
