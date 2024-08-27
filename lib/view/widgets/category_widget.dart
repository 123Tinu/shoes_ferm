import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/category_data_controller.dart';
import '../../model/category_model.dart';
import '../screens/category_page.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final CategoryDataController _categoryDataController =
      Get.put(CategoryDataController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: _categoryDataController.getCategoryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: Center(child: CupertinoActivityIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
          int dataLength = data.length;
          return SizedBox(
            height: 110,
            width: size.width,
            child: ListView.builder(
              itemCount: dataLength,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final productData = data[index];
                CategoriesModel categoryModel = CategoriesModel(
                  categoryId: productData['categoryId'],
                  categoryImg: productData['categoryImg'],
                  categoryName: productData['categoryName'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                );
                return Padding(
                  padding: const EdgeInsets.all(.0),
                  child: GestureDetector(
                    onTap: () => Get.to(
                        () => AllSingleCategoryProductsScreen(
                              categoryId: categoryModel.categoryId,
                            ),
                        transition: Transition.leftToRightWithFade),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey[200],
                                          radius: 39,
                                        ),
                                        CircleAvatar(
                                          radius: 38,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  categoryModel.categoryImg,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const ColoredBox(
                                                color: Colors.white,
                                                child: Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  categoryModel.categoryName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
