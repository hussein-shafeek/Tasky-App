import 'package:flutter/material.dart';

class CategoryModel {
  int id;
  String name;

  CategoryModel({required this.id, required this.name});

  static List<CategoryModel> categories = [
    CategoryModel(id: 1, name: 'All'),
    CategoryModel(id: 2, name: 'Inprogress'),
    CategoryModel(id: 3, name: 'Waiting'),
    CategoryModel(id: 4, name: 'Finished'),
  ];
}
