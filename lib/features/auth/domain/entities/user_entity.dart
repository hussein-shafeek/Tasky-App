import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String? displayName;

  const UserEntity({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    this.displayName,
  });

  @override
  List<Object?> get props => [userId];
}
