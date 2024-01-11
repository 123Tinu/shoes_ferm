import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetCategoryProductDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getCategoryProductData(
      String categoryId) async {
    final QuerySnapshot productData = await _firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return productData.docs;
  }
}
