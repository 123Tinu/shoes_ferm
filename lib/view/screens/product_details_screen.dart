import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/cart_product_controller.dart';
import '../../controller/favorites_product_controller.dart';
import '../../model/product_model.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;

  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CarouselController carouselController = CarouselController();
  final addFirebaseController = Get.put(AddFirebaseController());
  int currentIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;
  final CartItemController _cartItemController = Get.put(CartItemController());
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite =
          prefs.getBool('favorite_${widget.productModel.productId}') ?? false;
    });
  }

  Future<void> saveFavoriteStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_${widget.productModel.productId}', status);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size halfWidth = MediaQuery.of(context).size / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          width: size.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                icon: Icon(Icons.search, size: 25, color: Colors.black),
              ),
              onChanged: (value) {},
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Get.to(() => const CartScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.productModel.productName,
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.productModel.productName2,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        const Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              '4.5',
              style: TextStyle(color: Colors.orangeAccent, fontSize: 15),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.star,
              color: Colors.orangeAccent,
              size: 20,
            ),
            Icon(
              Icons.star,
              color: Colors.orangeAccent,
              size: 20,
            ),
            Icon(
              Icons.star,
              color: Colors.orangeAccent,
              size: 20,
            ),
            Icon(
              Icons.star,
              color: Colors.orangeAccent,
              size: 20,
            ),
            Icon(
              Icons.star_half,
              color: Colors.orangeAccent,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '(32)',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Stack(
          children: [
            CarouselSlider(
              items: widget.productModel.productImages
                  .map(
                    (imagePath) => Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Image.network(
                        widget.productModel.productImages[currentIndex],
                        fit: BoxFit.cover,
                        width: size.width,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 400,
                autoPlay: false,
                aspectRatio: 2.0,
                viewportFraction: 1,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 30,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          setState(() {
                            isFavorite = !isFavorite;
                          });

                          if (isFavorite) {
                            // If becoming favorite, add to Firebase
                            await addFirebaseController.addFavoriteItem(
                              uId: user!.uid,
                              productModel: widget.productModel,
                            );
                          } else {
                            // If removing from favorites, delete from Firebase
                            await addFirebaseController.deleteFavoriteItem(
                              uId: user!.uid,
                              productId: widget.productModel.productId,
                            );
                          }

                          // Save the favorite status to SharedPreferences
                          await saveFavoriteStatus(isFavorite);
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              widget.productModel.productImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => carouselController.animateToPage(entry.key),
              child: Container(
                width: currentIndex == entry.key ? 17 : 7,
                height: 7.0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentIndex == entry.key ? Colors.red : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                              image: NetworkImage(
                                  widget.productModel.productImages[0]),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                              image: NetworkImage(
                                  widget.productModel.productImages[1]),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                              image: NetworkImage(
                                  widget.productModel.productImages[2]),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 3;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                              image: NetworkImage(
                                  widget.productModel.productImages[3]),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 4;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                              image: NetworkImage(
                                  widget.productModel.productImages[4]),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Rs. ${widget.productModel.fullPrice}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productModel.productDescription,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        )
      ])),
      bottomNavigationBar:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: halfWidth.width,
          height: 56,
          color: Colors.white,
          child: TextButton(
              onPressed: () async {
                try {
                  await _cartItemController.checkProductExistence(
                      uId: user!.uid, productModel: widget.productModel);
                  // Navigate to the CartScreen
                  // Get.to(() => const Cart());
                } catch (e) {
                  if (kDebugMode) {
                    print("Error adding to cart: $e");
                  }
                }
              },
              child: const Text(
                "Add to cart",
                style: TextStyle(color: Colors.black, fontSize: 21),
              )),
        ),
        Container(
          width: halfWidth.width,
          height: 56,
          color: Colors.black,
          child: TextButton(
              onPressed: () {
                Get.off(() => const CartScreen(),
                    transition: Transition.leftToRightWithFade);
              },
              child: const Text(
                "Buy now",
                style: TextStyle(color: Colors.white, fontSize: 21),
              )),
        ),
      ]),
    );
  }
}
