import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetProductDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getProductData() async {
    final QuerySnapshot productData = await _firestore
        .collection('products')
        .where('isSale', isEqualTo: true)
        .get();
    return productData.docs;
  }
}
