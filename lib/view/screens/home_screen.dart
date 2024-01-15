import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/product_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "Settings";
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      ),
      body: ListView(
          children: const [
        Column(
            children: [
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment(-0.96, 0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Trending Deals",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          BannerWidget(),
              SizedBox(
                height: 10,
              ),
          CategoryWidget(),
          Align(
            alignment: Alignment(-0.96, 0),
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text("Top Selection",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  )),
            ),
          ),
              SizedBox(
                height: 5,
              ),
          GetProductWidget(),
        ]),
      ]),
    );
  }
}
