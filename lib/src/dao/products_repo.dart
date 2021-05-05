import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vpay/src/models/transaction.dart' as tran;
import 'package:vpay/src/models/category.dart';

class ProductsRepo {
  final CollectionReference ref = Firestore.instance.collection('products');

  final CollectionReference catRef =
      Firestore.instance.collection('categories');

  final CollectionReference transRef =
      Firestore.instance.collection('transactions');

  List<Product> products = [];
  List<Category> categories = [];
  List<tran.Transaction> _transactions = [];

  Future<Query> getProductsAsQuery() async {
    return ref.orderBy("name");
  }

  Future<List<Product>> getProductsList() async {
    await ref.orderBy("name").getDocuments().then(
      (e) {
        products = e.documents.map((f) => Product.fromSnapshot(f)).toList();
      },
    ).whenComplete(() {
      print("number of products: ${products.length}");
    });
    return products;
  }

  Future<List<Category>> getCategories() async {
    await catRef.orderBy("id").getDocuments().then(
      (e) {
        categories = e.documents.map((f) => Category.fromSnapshot(f)).toList();
      },
    ).whenComplete(() {
      print("number of categories: ${categories.length}");
    });

    return categories;
  }

  Future<void> getTransactions() async {
    await transRef.orderBy("timestamp", descending: true).getDocuments().then(
      (e) {
        _transactions =
            e.documents.map((f) => tran.Transaction.fromSnapshot(f)).toList();
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
    ref.add(product.toJson()).whenComplete(() {}).whenComplete(() {
      print("Product added successfully!");
    }).then((e) {
      getProductByRef(product.reference);
    });
  }

  Future<void> deleteproduct(Product product) async {
    product.reference.delete().whenComplete(() {});
  }

  Future<void> modifyproduct(Product product) async {
    product.reference.updateData(product.toJson()).whenComplete(() {
      // getData();
    });
  }

  Future<void> modifyProducts(List<Product> products) async {
    products.forEach((f) {
      f.reference.updateData(f.toJson());
    });
  }

  Future<void> addCategory(Category category) async {
    ref.add(category.toJson()).whenComplete(() {});
  }

  Future<void> deleteCategory(Category category) async {
    category.reference.delete().whenComplete(() {});
  }

  Future<void> modifyCategory(Category newCategory, String oldCategory) async {
    await newCategory.reference
        .updateData(newCategory.toJson())
        .whenComplete(() {
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
