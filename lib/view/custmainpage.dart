import 'package:flutter/material.dart';
import 'package:lab3/model/user.dart';
import 'package:lab3/view/custtabpage2.dart';
import 'cartpage.dart';
import 'homepage.dart';

class CustMainPage extends StatefulWidget {
  final User user;
  const CustMainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CustMainPage> createState() => _CustMainPageState();
}

class _CustMainPageState extends State<CustMainPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      TabPage1(user: widget.user),
      CustTabPage2(user: widget.user),
      CartPage(user: widget.user),
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
              icon: Icon(Icons.shopping_bag), label: "My Cart"),
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
