import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/screens/checkout_screen.dart';
import '../../controller/cart_price_controller.dart';
import '../../model/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void dispose() {
    super.dispose();
    _productPriceController.dispose();
  }

  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController _productPriceController =
      Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error",
                style: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No products found!",
                style: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular'),
              ),
            );
          }
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                CartModel cartModel = CartModel(
                  productId: productData['productId'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  productName2: productData['productName2'],
                  categoryName: productData['categoryName'],
                  salePrice: productData['salePrice'],
                  fullPrice: productData['fullPrice'],
                  productImages: productData['productImages'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                  productQuantity: productData['productQuantity'],
                  productTotalPrice:
                      double.parse(productData['productTotalPrice'].toString()),
                );
                _productPriceController.fetchProductPrice();
                return SwipeActionCell(
                  key: ObjectKey(cartModel.productId),
                  trailingActions: [
                    SwipeAction(
                      title: "Remove",
                      forceAlignmentToBoundary: true,
                      performsFirstActionWithFullSwipe: true,
                      onTap: (CompletionHandler handler) async {
                        if (kDebugMode) {
                          print('Removed');
                        }

                        await FirebaseFirestore.instance
                            .collection('cart')
                            .doc(user!.uid)
                            .collection('cartOrders')
                            .doc(cartModel.productId)
                            .delete();

                        // Update the total price after deleting an item
                        _productPriceController.fetchProductPrice();
                        handler(false);
                      },
                    )
                  ],
                  child: buildCartCard(cartModel),
                );
              },
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                " Total  : ${_productPriceController.totalPrice.value.toStringAsFixed(1)} rs",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: const Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_productPriceController.totalPrice.value > 0) {
                        // Navigate to CheckoutPage only if the cart is not empty
                        Get.to(() => const CheckoutScreen());
                      } else {
                        // Show a message or perform any action when the cart is empty
                        Get.snackbar(
                          'Empty Cart',
                          'Your cart is empty. Add some items to proceed to checkout.',
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCartCard(CartModel cartModel) {
    return Card(
      color: Colors.white,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
              bottom: Radius.circular(10),
            ),
            child: SizedBox(
              height: 130,
              width: 130,
              child: Image.network(
                "${cartModel.productImages[0]}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  cartModel.productName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Row(
                  children: [
                    Text(
                      '4.5',
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 10),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                      size: 13,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                      size: 13,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                      size: 13,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                      size: 13,
                    ),
                    Icon(
                      Icons.star_half,
                      color: Colors.orangeAccent,
                      size: 13,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '(32)',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 8),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (cartModel.productQuantity > 1) {
                          if (kDebugMode) {
                            print('Decreasing quantity');
                          }
                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .update({
                            'productQuantity': cartModel.productQuantity - 1,
                            'productTotalPrice':
                                (double.parse(cartModel.fullPrice) *
                                    (cartModel.productQuantity - 1)),
                          });

                          if (kDebugMode) {
                            print(
                                'Updated quantity: ${cartModel.productQuantity - 1}');
                          }
                          if (kDebugMode) {
                            print(
                                'Updated total price: ${double.parse(cartModel.fullPrice) * (cartModel.productQuantity - 1)}');
                          }
                        }
                      },
                      child: const CircleAvatar(
                        radius: 15.0,
                        backgroundColor: Colors.black,
                        child: Text(
                          '-',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${cartModel.productQuantity}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (cartModel.productQuantity > 0) {
                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .update({
                            'productQuantity': cartModel.productQuantity + 1,
                            'productTotalPrice':
                                double.parse(cartModel.fullPrice) +
                                    double.parse(cartModel.fullPrice) *
                                        (cartModel.productQuantity),
                          });
                        }
                      },
                      child: const CircleAvatar(
                        radius: 15.0,
                        backgroundColor: Colors.black,
                        child: Text(
                          '+',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Rs. ${cartModel.productTotalPrice.toString()}",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
