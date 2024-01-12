import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/main_screen.dart';
import '../../controller/category_product_controller.dart';
import '../../model/product_model.dart';

class AllSingleCategoryProductsScreen extends StatefulWidget {
  String categoryId;

  AllSingleCategoryProductsScreen({super.key, required this.categoryId});

  @override
  State<AllSingleCategoryProductsScreen> createState() =>
      _AllSingleCategoryProductsScreenState();
}

class _AllSingleCategoryProductsScreenState
    extends State<AllSingleCategoryProductsScreen> {
  final GetCategoryProductDataController _getCategoryProductDataController =
      Get.put(GetCategoryProductDataController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button behavior here
        Get.off(() => const MainScreen(),
            transition: Transition.leftToRightWithFade);
        return false; // Return false to prevent the default back button behavior
      },
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.off(() => const MainScreen(),
                transition: Transition.leftToRightWithFade),
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
          ),
          centerTitle: true,
          title: const Text(
            "Category products",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                future: _getCategoryProductDataController
                    .getCategoryProductData(widget.categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Return a loading indicator or placeholder widget
                    return const SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    // Handle error
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Data has been loaded successfully
                    List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
                    int dataLength = data.length;

                    // Rest of your widget tree using the 'data'

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: dataLength,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.80,
                        ),
                        itemBuilder: (context, index) {
                          final productData = data[index];
                          ProductModel productModel = ProductModel(
                            productId: productData['productId'],
                            categoryId: productData['categoryId'],
                            productName: productData['productName'],
                            productName2: productData['productName2'],
                            categoryName: productData['categoryName'],
                            salePrice: productData['salePrice'].toString(),
                            fullPrice: productData['fullPrice'].toString(),
                            productImages: productData['productImages'],
                            deliveryTime: productData['deliveryTime'],
                            isSale: productData['isSale'],
                            productDescription:
                                productData['productDescription'],
                            createdAt: productData['createdAt'],
                            updatedAt: productData['updatedAt'],
                          );

                          return ProductCard(productModel: productModel);
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}

// Add the ProductCard class here
class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  const ProductCard({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => ProductDetailsScreen(productModel: productModel));
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: SizedBox(
                height: 170,
                width: double.infinity,
                child: Image.network(
                  "${productModel.productImages[0]}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              productModel.productName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                productModel.productName2,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              ' ₹ ${productModel.fullPrice}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
