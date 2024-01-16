import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_ferm/view/screens/product_details_screen.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Category",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
        future: _getCategoryProductDataController
            .getCategoryProductData(widget.categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CupertinoActivityIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
            int dataLength = data.length;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: dataLength,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    productDescription: productData['productDescription'],
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
    );
  }
}

// Add the ProductCard class here
class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  const ProductCard({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailsScreen(productModel: productModel));
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
                height: 130,
                child: Image.network(
                  height: size.height,
                  width: size.width,
                  "${productModel.productImages[0]}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              productModel.productName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              productModel.productName2,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              ' ₹ ${productModel.fullPrice}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
