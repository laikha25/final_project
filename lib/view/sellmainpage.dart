import 'package:flutter/material.dart';
import 'package:lab3/model/user.dart';
import 'package:lab3/view/selltabpage2.dart';
import 'homepage.dart';
import 'orderspage.dart';

class SellMainPage extends StatefulWidget {
  final User user;
  const SellMainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SellMainPage> createState() => _SellMainPageState();

  void checklogin() {}
}

class _SellMainPageState extends State<SellMainPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      TabPage1(
        user: widget.user,
      ),
      SellTabPage2(user: widget.user),
      const TabPage3(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Orders"),
        ],
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Profile";
      }
      if (_currentIndex == 2) {
        maintitle = "Orders";
      }
    });
  }
}
