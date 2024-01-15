import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/product_controller.dart';
import '../../model/product_model.dart';
import '../screens/product_details_screen.dart';

class GetProductWidget extends StatefulWidget {
  const GetProductWidget({super.key});

  @override
  State<GetProductWidget> createState() => _GetProductWidgetState();
}

class _GetProductWidgetState extends State<GetProductWidget> {
  final GetProductDataController _getProductDataController =
      Get.put(GetProductDataController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: _getProductDataController.getProductData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: 20.w,
              height: 20.h,
              child: const Center(child: CupertinoActivityIndicator()));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
          int dataLength = data.length;
          return Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 0.80,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataLength,
                itemBuilder: (BuildContext context, int index) {
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
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          ProductDetailsScreen(productModel: productModel));
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.white,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: SizedBox(
                              height: 140,
                              child: Image.network(
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
                },
              ),
            ],
          );
        }
      },
    );
  }
}
