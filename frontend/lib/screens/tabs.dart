import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/cart_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/liked_products.dart';
import 'package:frontend/screens/orders.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/widgets/drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TasbScreenState();
  }
}

class _TasbScreenState extends State<TabsScreen> {
  int currentIndex = 0;
  Widget activeScreen = const HomeScreen();
  void selectScreen(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex == 0) {
      setState(() {
        activeScreen = const HomeScreen();
      });
    } else if (currentIndex == 1) {
      setState(() {
        activeScreen = const LikedProducts();
      });
    } else if (currentIndex == 2) {
      setState(() {
        activeScreen = const CartScreen();
      });
    } else if (currentIndex == 3) {
      setState(() {
        activeScreen = const OrdersScreen();
      });
    }
    return Scaffold(
      body: activeScreen,
      drawer: const DrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: selectScreen,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'Liked Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          )
        ],
      ),
    );
  }
}
