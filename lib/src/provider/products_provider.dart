import 'package:flutter/foundation.dart' as f;
import 'package:vpay/src/models/category.dart';
import 'package:vpay/src/dao/products_dao.dart';

class ProductsProvider extends f.ChangeNotifier {
  ProductsDao dao = ProductsDao();
  List<Category> categories = [];
  List<Product> products = [];

  ProductsProvider() {
    getData();
  }

  getData() {
    dao.getCategories().then((value) {
      setCategories(value);
    });
    dao.getProductsList().then((value) {
      setProducts(value);
    });
  }

  Future refresh() async {
    return await Future.delayed(
      Duration(seconds: 2),
      () async {
        getData();
      },
    );
  }

  setProducts(List<Product> products) {
    this.products = products;
    notifyListeners();
  }

  setCategories(List<Category> categories) {
    this.categories = categories;
    notifyListeners();
  }

  List<Product> getProductsByCategory(String categoryName) {
    return products.where((product) {
      return product.category == categoryName;
    }).toList();
  }
}
