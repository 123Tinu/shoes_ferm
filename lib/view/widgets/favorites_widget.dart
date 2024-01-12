import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../controller/favorites_product_controller.dart';
import '../../model/favorite_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final addFirebaseController = Get.put(AddFirebaseController());
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorite')
            .doc(user!.uid)
            .collection('favoriteItems')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Favourite screen is empty.'));
          }
          final favoriteItem = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoriteItem.length,
            itemBuilder: (context, index) {
              final cartItem = favoriteItem[index];
              final cartProduct = FavoriteModel.fromMap(
                  cartItem.data() as Map<String, dynamic>);

              return Dismissible(
                key: Key(cartProduct.productId),
                onDismissed: (direction) async {
                  await addFirebaseController.deleteFavoriteItem(
                    uId: user!.uid,
                    productId: cartProduct.productId,
                  );
                },
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: SizedBox(
                            height: 170,
                            width: 140, // Adjust the width as needed
                            child: Image.network(
                              "${cartProduct.productImages[0]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Adjust the spacing as needed
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartProduct.productName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  cartProduct.categoryName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                  ),
                                  Icon(
                                    Icons.star_half,
                                    color: Colors.orangeAccent,
                                  ),
                                  Icon(
                                    Icons.star_border,
                                    color: Colors.orangeAccent,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    ' ₹ ${cartProduct.fullPrice}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
