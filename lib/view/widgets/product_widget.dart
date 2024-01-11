import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/product_controller.dart';
import '../../model/product_model.dart';

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
          // Return a loading indicator or placeholder widget
          return SizedBox(
              width: 20.w,
              height: 20.h,
              child: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error: ${snapshot.error}');
        } else {
          // // Data has been loaded successfully
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
          int dataLength = data.length;

          // Rest of your widget tree using the 'data'
          return Column(
            children: [
              SizedBox(
                // width: MediaQuery.of(context).size.height,
                // height: MediaQuery.of(context).size.width,
                child: GridView.builder(
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
                        // Get.to(() =>
                        //     ProductDetailsScreen(productModel: productModel));
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
                                height: 170,
                                width: double.infinity,
                                child: Image.network(
                                  height: size.height,
                                  width: size.width,
                                  "${productModel.productImages[index]}",
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
                  },
                ),
              ),
            ],
          );
          // return Text(dataLength.toString());
        }
      },
    );
  }
}
