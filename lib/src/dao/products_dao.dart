import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vpay/src/models/transaction.dart' as tran;
import 'package:vpay/src/models/category.dart';

class ProductsDao {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('products');

  final CollectionReference catRef =
      FirebaseFirestore.instance.collection('categories');

  final CollectionReference transRef =
      FirebaseFirestore.instance.collection('transactions');

  List<Product> products = [];
  List<Category> categories = [];
  List<tran.Transaction> _transactions = [];

  Future<Query> getProductsAsQuery() async {
    return _ref.orderBy("name");
  }

  Future<List<Product>> getProductsList() async {
    await _ref.orderBy("name").get().then(
      (e) {
        products = e.docs.map((f) => Product.fromSnapshot(f)).toList();
      },
    ).whenComplete(() {
      print("number of products: ${products.length}");
    });
    return products;
  }

  Future<List<Category>> getCategories() async {
    await catRef.orderBy("id").get().then(
      (e) {
        categories = e.docs.map((f) => Category.fromSnapshot(f)).toList();
      },
    ).whenComplete(() {
      print("number of categories: ${categories.length}");
    });

    return categories;
  }

  Future<void> getTransactions() async {
    await transRef.orderBy("timestamp", descending: true).get().then(
      (e) {
        _transactions =
            e.docs.map((f) => tran.Transaction.fromSnapshot(f)).toList();
      },
    ).whenComplete(() {
      print("number of transactions: ${_transactions.length}");
    });
    return _transactions;
  }

  Product getProductById(String id) {
    Product product;
    product = products.singleWhere((product) {
      return id == product.name;
    });
    return product;
  }

  Product getProductByRef(DocumentReference reference) {
    return products.singleWhere((product) {
      return reference == product.reference;
    });
  }

  List<Product> searchProductsList(String searchValue) {
    List<Product> result = [];
    if (searchValue.isNotEmpty)
      products.forEach((f) {
        if (f.name.toLowerCase().contains(searchValue)) result.add(f);
      });
    return result;
  }

  Future<void> addproduct(Product product) async {
    _ref.add(product.toJson()).whenComplete(() {}).whenComplete(() {
      print("Product added successfully!");
    }).then((e) {
      getProductByRef(product.reference);
    });
  }

  Future<void> deleteproduct(Product product) async {
    product.reference.delete().whenComplete(() {});
  }

  Future<void> modifyproduct(Product product) async {
    product.reference.update(product.toJson()).whenComplete(() {
      // getData();
    });
  }

  Future<void> modifyProducts(List<Product> products) async {
    products.forEach((f) {
      f.reference.update(f.toJson());
    });
  }

  Future<void> addCategory(Category category) async {
    _ref.add(category.toJson()).whenComplete(() {});
  }

  Future<void> deleteCategory(Category category) async {
    category.reference.delete().whenComplete(() {});
  }

  Future<void> modifyCategory(Category newCategory, String oldCategory) async {
    await newCategory.reference.update(newCategory.toJson()).whenComplete(() {
      products.forEach((product) {
        if (product.category == oldCategory)
          product.category = newCategory.name;
        modifyproduct(product);
      });
    }).whenComplete(() {});
  }

  Future<void> runModifications(List<CartModel> models) async {
    models.forEach((model) {
      print("quantity: ${model.product.quantity}");
      modifyproduct(model.product);
    });
  }

  List<tran.Transaction> get transactions => _transactions;

  Future<void> addTransaction(tran.Transaction transaction,
      List<tran.TransactionDetails> details) async {
    transRef.add(transaction.toJson()).then((transaction) {
      details.forEach((detail) {
        transaction.collection('details').add(detail.toJson());
      });
    });
  }
}
