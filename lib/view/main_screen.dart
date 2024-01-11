import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shoes_ferm/view/screens/cart_screen.dart';
import 'package:shoes_ferm/view/screens/favorites_screen.dart';
import 'package:shoes_ferm/view/screens/home_screen.dart';
import 'package:shoes_ferm/view/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentSelectedIndex = 0;
  static final List pages = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const SettingsScreen()
  ];
  var titles = ["Home", "Favorites", "Cart", "Settings"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.0,
        centerTitle: true,
        title: Text(
          titles[currentSelectedIndex],
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: pages[currentSelectedIndex],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey,
            gap: 8,
            padding: const EdgeInsets.all(15),
            onTabChange: (index) {
              setState(() {
                currentSelectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'favorites',
              ),
              GButton(
                icon: Icons.shopping_cart,
                text: 'Cart',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              )
            ]),
      ),
    );
  }
}
