import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/cart_model.dart';
import '../model/product_model.dart';


class CartItemController extends GetxController {
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
    required ProductModel productModel,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;

      try {
        double totalPrice = double.tryParse(
          productModel.isSale
              ? productModel.salePrice.replaceAll(',', '')
              : productModel.fullPrice.replaceAll(',', ''),
        ) ?? 0.0;

        totalPrice *= updatedQuantity;

        await documentReference.update({
          'productQuantity': updatedQuantity,
          'productTotalPrice': totalPrice,
        });

        Get.snackbar("Product exists", "Update quantity");
        print("Product exists");
      } catch (e) {
        print("Error updating quantity: $e");
      }
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );

      CartModel cartModel = CartModel(
        productId: productModel.productId,
        categoryId: productModel.categoryId,
        productName: productModel.productName,
        productName2: productModel.productName2,
        categoryName: productModel.categoryName,
        salePrice: productModel.salePrice,
        fullPrice: productModel.fullPrice,
        productImages: productModel.productImages,
        deliveryTime: productModel.deliveryTime,
        isSale: productModel.isSale,
        productDescription: productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(
          productModel.isSale
              ? productModel.salePrice.replaceAll(',', '')
              : productModel.fullPrice.replaceAll(',', ''),
        ),
      );

      await documentReference.set(cartModel.toMap());

      Get.snackbar("Success", "Product added");
    }
  }
}