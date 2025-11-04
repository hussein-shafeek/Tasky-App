import 'package:flutter/material.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });

  static List<OnboardingModel> getPages(BuildContext context) {
    return [
      OnboardingModel(
        image: 'art',
        title: 'Task Management & \nTo-Do List',
        description:
            'This productive tool is designed to help \nyou better manage your task \nproject-wise conveniently!',
      ),
    ];
  }
}
