import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorbin/menu/model/menu_model.dart';

class FirestoreFunctions {

  ///used for store order data in firestore
  static Future<void> addOrder(Map<String, CategoryModel> cartData) async {
    try {
      final instance = FirebaseFirestore.instance.collection('orders');
      cartData.forEach((key, value) async {
        final oldData = await instance.doc(key).get();
        final oldMap = oldData.data();
        if (oldMap != null) {
          final oldCategoryModel = CategoryModel.fromMap(oldMap);
          final newCategoryModel = CategoryModel(
              name: oldCategoryModel.name,
              price: oldCategoryModel.price + value.price,
              instock: value.instock,
              quantity: oldCategoryModel.quantity + value.quantity);
          instance.doc(key).update(newCategoryModel.toMap());
        } else {
          instance
              .doc(key)
              .set(value.toMap())
              .then((value) => print("Added"))
              .catchError((error) => throw error);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  ///used for get order data from firestore
  static Future<List<CategoryModel>> getUpdatedOrdersList() async {
    try {
      List<CategoryModel> allOrderData = [];
      final instance = FirebaseFirestore.instance.collection('orders');
      Query collectionReference = instance.orderBy('quantity',descending: true);
      final list = await collectionReference.get();
      for (var element in list.docs) {
        allOrderData.add(CategoryModel.fromMap(element.data() as Map<String,dynamic>));
      }
      return allOrderData;
    } catch (e) {
      rethrow;
    }
  }
}
