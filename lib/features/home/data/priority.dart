import 'dart:ui';

enum Priority {
  low,
  medium,
  high;

  static Priority fromName(String? name) {
    if (name == null) return Priority.low;
    try {
      return Priority.values.firstWhere(
        (e) => e.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return Priority.low;
    }
  }

  String get label {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case Priority.low:
        return const Color(0xFF4CAF50);
      case Priority.medium:
        return const Color(0xFF2196F3);
      case Priority.high:
        return const Color(0xFFFF7043);
    }
  }
}
