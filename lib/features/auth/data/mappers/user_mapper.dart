import 'package:tasky_app/features/auth/domain/entities/user_entity.dart';

extension UserMapper on UserEntity {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      accessToken: accessToken,
      refreshToken: refreshToken,
      displayName: displayName,
    );
  }
}
