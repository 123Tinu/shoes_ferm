import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../model/cart_model.dart';
import '../model/favorite_model.dart';
import '../model/product_model.dart';

class AddFirebaseController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  num totalPriceFinal = 0;
  num cartTotal = 0.0;

  Future<void> deleteFavoriteItem({
    required String uId,
    required String productId,
    int quantityDecrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('favorite')
        .doc(uId)
        .collection('favoriteItems')
        .doc(productId);

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      await documentReference.delete();
      Get.snackbar(
        "Item",
        "Removed from favorites",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> addFavoriteItem(
      {required String uId,
      required ProductModel productModel,
      int quantityIncrement = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('favorite')
        .doc(uId)
        .collection('favoriteItems')
        .doc(productModel.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      if (kDebugMode) {
        print("Product already exist");
      }
      if (kDebugMode) {
        print("Product quantity updated: $quantityIncrement");
      }
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      if (kDebugMode) {
        print("Product quantity updated: $updatedQuantity");
      }
      double totalPrice = double.parse(productModel.isSale
              ? productModel.salePrice
              : productModel.fullPrice) *
          updatedQuantity;

      if (kDebugMode) {
        print("Product quantity updated: $totalPrice");
      }
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      Get.snackbar(
        "Product Added to favorite",
        "${productModel.productName} to favorite",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('favorite')
          .doc(uId)
          .set({'uId': uId, 'createdAt': DateTime.now()});
      FavoriteModel favoriteModel = FavoriteModel(
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
      await documentReference.set(favoriteModel.toMap());

      Get.snackbar(
        "Product Added to favorite",
        "You have added the ${productModel.productName}",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      if (kDebugMode) {
        print("product added");
      }
    }
  }

  Future<void> checkProductExistence(
      {required String uId,
      required ProductModel productModel,
      int quantityIncrement = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(productModel.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      if (kDebugMode) {
        print("Product already exist");
      }
      if (kDebugMode) {
        print("Product quantity updated: $quantityIncrement");
      }
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      if (kDebugMode) {
        print("Product quantity updated: $updatedQuantity");
      }
      double totalPrice = double.parse(productModel.isSale
              ? productModel.salePrice
              : productModel.fullPrice) *
          updatedQuantity;
      if (kDebugMode) {
        print("Product quantity updated: $totalPrice");
      }
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      Get.snackbar(
        "Product quantity updated",
        "${productModel.productName} to the cart",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(uId)
          .set({'uId': uId, 'createdAt': DateTime.now()});
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
        productTotalPrice: double.parse(productModel.isSale
            ? productModel.salePrice
            : productModel.fullPrice),
      );
      await documentReference.set(cartModel.toMap());

      Get.snackbar(
        "Product Added",
        "You have added the ${productModel.productName} to the cart",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      if (kDebugMode) {
        print("product added");
      }
    }
  }

  Future<void> incrementCartItemQuantity({
    required String uId,
    required String productId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(productId);

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      if (kDebugMode) {
        print('currentQuantity: $currentQuantity');
      }
      double productTotalPrice =
          double.parse('${snapshot['productTotalPrice']}');
      if (kDebugMode) {
        print('productTotalPrice: $productTotalPrice');
      }
      int updatedQuantity = currentQuantity + quantityIncrement;
      bool isSale = bool.parse('${snapshot['isSale']}');
      double unitPrice = double.parse(
          isSale ? '${snapshot['salePrice']}' : '${snapshot['fullPrice']}');
      double totalPrice = unitPrice * updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      if (kDebugMode) {
        print("Quantity incremented by $quantityIncrement");
      }
    } else {
      if (kDebugMode) {
        print("Product not found in the cart");
      }
    }
  }

  Future<void> decrementCartItemQuantity({
    required String uId,
    required String productId,
    int quantityDecrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(productId);

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      if (kDebugMode) {
        print('currentQuantity: $currentQuantity');
      }
      double productTotalPrice =
          double.parse('${snapshot['productTotalPrice']}');
      if (kDebugMode) {
        print('productTotalPrice: $productTotalPrice');
      }
      if (currentQuantity >= quantityDecrement) {
        int updatedQuantity = currentQuantity - quantityDecrement;
        bool isSale = bool.parse('${snapshot['isSale']}');
        double unitPrice = double.parse(
            isSale ? '${snapshot['salePrice']}' : '${snapshot['fullPrice']}');
        double totalPrice = unitPrice * updatedQuantity;
        await documentReference.update({
          'productQuantity': updatedQuantity,
          'productTotalPrice': totalPrice
        });
      } else {
        await documentReference.delete();
        if (kDebugMode) {
          print("Product removed from the cart");
        }
      }
    } else {
      if (kDebugMode) {
        print("Product not found in the cart");
      }
    }
  }

  Future<num> calculatingTotalPrice(String uId) async {
    double totalPrice = 0.0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .get();

    for (int i = 0; i < qn.docs.length; i++) {
      final productTotalPrice = qn.docs[i]["productTotalPrice"];
      if (productTotalPrice is double) {
        totalPrice += productTotalPrice;
      }
    }

    totalPriceFinal = totalPrice;
    if (kDebugMode) {
      print('total $totalPriceFinal');
    }
    return totalPriceFinal;
  }
}
