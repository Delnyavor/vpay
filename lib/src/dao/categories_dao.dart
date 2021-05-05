import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vpay/src/models/category.dart';

class ProductsRepo {
  final CollectionReference ref = Firestore.instance.collection('categories');

  List<Category> categories = [];

  Future<List<Category>> getCategories() async {
    await ref.orderBy("id").getDocuments().then(
      (e) {
        categories = e.documents.map((f) => Category.fromSnapshot(f)).toList();
      },
    ).whenComplete(() {
      print("number of categories: ${categories.length}");
    });

    return categories;
  }

  Future<void> addCategory(Category category) async {
    ref.add(category.toJson()).whenComplete(() {});
  }

  Future<void> deleteCategory(Category category) async {
    category.reference.delete().whenComplete(() {});
  }

  Future<void> modifyCategory(
    Category newCategory,
    String oldCategory,
  ) async {
    await newCategory.reference.updateData(newCategory.toJson());
  }
}
