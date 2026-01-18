import 'package:tasky_app/features/profile/data/models/profile_model.dart';
import 'package:tasky_app/features/profile/domain/entities/profile_entity.dart';

extension ProfileMapper on ProfileModel {
  ProfileEntity get toEntity => ProfileEntity(
    id: id,
    phone: phone,
    displayName: displayName,
    experienceYears: experienceYears,
    address: address,
    level: level,
  );
}
