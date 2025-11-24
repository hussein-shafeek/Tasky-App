class CategoryModel {
  int id;
  String label;
  String value;

  CategoryModel({required this.id, required this.label, required this.value});

  static List<CategoryModel> categories = [
    CategoryModel(id: 1, label: 'All', value: 'all'),
    CategoryModel(id: 2, label: 'Inprogress', value: 'inprogress'),
    CategoryModel(id: 3, label: 'Waiting', value: 'waiting'),
    CategoryModel(id: 4, label: 'Finished', value: 'finished'),
  ];
}
