import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/screens/checkout_screen.dart';

import '../../controller/cart_price_controller.dart';
import '../../model/cart_model.dart';


class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController _productPriceController =
  Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cart')
                    .doc(user!.uid)
                    .collection('cartOrders')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Error",
                      style: TextStyle(
                        fontSize: 20,
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
                    return const Text(
                      "No products found!",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Roboto-Regular'),
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
                          productDescription:
                          productData['productDescription'],
                          createdAt: productData['createdAt'],
                          updatedAt: productData['updatedAt'],
                          productQuantity: productData['productQuantity'],
                          productTotalPrice: double.tryParse(
                            productData['productTotalPrice']
                                .toString()
                                .replaceAll(',', ''),
                          ) ??
                              0.0,
                        );

                        return SwipeActionCell(
                          key: ObjectKey(cartModel.productId),
                          trailingActions: [
                            SwipeAction(
                              title: "Delete",
                              forceAlignmentToBoundary: true,
                              performsFirstActionWithFullSwipe: true,
                              onTap: (CompletionHandler handler) async {
                                print('deleted');

                                await FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(user!.uid)
                                    .collection('cartOrders')
                                    .doc(cartModel.productId)
                                    .delete();

                                // Call updateCartTotalPrice after deleting the cart item
                                updateCartTotalPrice();
                              },
                            )
                          ],
                          child: SizedBox(
                            child: Card(
                              elevation: 5,
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    cartModel.productImages[0],
                                    scale: 1.0,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartModel.productName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        cartModel.categoryName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                            "Price: ${cartModel.productTotalPrice.toString()}"),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (cartModel
                                                    .productQuantity >
                                                    1) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('cart')
                                                      .doc(user!.uid)
                                                      .collection('cartOrders')
                                                      .doc(cartModel.productId)
                                                      .update({
                                                    'productQuantity':
                                                    FieldValue.increment(
                                                        -1),
                                                    'productTotalPrice':
                                                    FieldValue.increment(
                                                      -double.parse(cartModel
                                                          .fullPrice
                                                          .replaceAll(',', '')),
                                                    ),
                                                  });

                                                  // Call fetchProductPrice after updating the cart
                                                  _productPriceController
                                                      .fetchProductPrice();
                                                }
                                              },
                                              child: const CircleAvatar(
                                                radius: 16,
                                                backgroundColor: Colors.red,
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width / 20.0,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await FirebaseFirestore
                                                    .instance
                                                    .collection('cart')
                                                    .doc(user!.uid)
                                                    .collection('cartOrders')
                                                    .doc(cartModel.productId)
                                                    .update({
                                                  'productQuantity':
                                                  FieldValue.increment(1),
                                                  'productTotalPrice':
                                                  FieldValue.increment(
                                                    double.parse(cartModel
                                                        .fullPrice
                                                        .replaceAll(',', '')),
                                                  ),
                                                });

                                                // Call fetchProductPrice after updating the cart
                                                _productPriceController
                                                    .fetchProductPrice();
                                              },
                                              child: const CircleAvatar(
                                                radius: 16,
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 22,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                            "Quantity: ${cartModel.productQuantity}")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  // Call updateCartTotalPrice here if there are items in the cart
                  updateCartTotalPrice();

                  return Container();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                    () => Text(
                  " Total ₹ : ${_productPriceController.totalPrice.value.toStringAsFixed(1)} rs",
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
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
                            snackPosition: SnackPosition.BOTTOM,
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
      ),
    );
  }

  void updateCartTotalPrice() {
    // Calculate the total price from the cart items and update the controller
    double totalPrice = 0.0;

    // Fetch the cart items from Firestore
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get()
        .then((querySnapshot) {
      for (QueryDocumentSnapshot productData in querySnapshot.docs) {
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
          productTotalPrice: double.tryParse(
            productData['productTotalPrice']
                .toString()
                .replaceAll(',', ''),
          ) ??
              0.0,
        );
        totalPrice += cartModel.productTotalPrice;
      }

      // Update the total price in the controller
      _productPriceController.totalPrice.value = totalPrice;
    }).catchError((error) {
      print("Error fetching cart items: $error");
    });
  }
}