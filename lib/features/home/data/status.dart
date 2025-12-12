import 'dart:ui';

sealed class Status {
  const Status();

  String get value;
  String get label;
  Color get color;
  Color get textColor;

  static Status fromName(String? name) {
    if (name == null) return const Waiting();
    final n = name.toLowerCase();
    if (n == 'inprogress' || n == 'in_progress' || n == 'in progress') {
      return const InProgress();
    } else if (n == 'waiting' || n == 'pending') {
      return const Waiting();
    } else if (n == 'finished' || n == 'done' || n == 'completed') {
      return const Finished();
    } else {
      return const Waiting();
    }
  }
}

class InProgress extends Status {
  const InProgress();
  @override
  String get value => 'inprogress';
  @override
  String get label => 'In Progress';
  @override
  Color get color => const Color(0xFFEDE7F6);
  @override
  Color get textColor => const Color(0xFF673AB7);
}

class Waiting extends Status {
  const Waiting();
  @override
  String get value => 'waiting';
  @override
  String get label => 'Waiting';
  @override
  Color get color => const Color(0xFFFFEBEE);
  @override
  Color get textColor => const Color(0xFFD32F2F);
}

class Finished extends Status {
  const Finished();
  @override
  String get value => 'finished';
  @override
  String get label => 'Finished';
  @override
  Color get color => const Color(0xFFE3F2FD);
  @override
  Color get textColor => const Color(0xFF0277BD);
}
