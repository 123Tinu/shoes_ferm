import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CategoryDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getCategoryData() async {
    final QuerySnapshot categoryData =
        await _firestore.collection('categories').get();
    return categoryData.docs;
  }
}
