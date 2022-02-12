import 'package:flutter/material.dart';

void main() => runApp(const TabPage3());

class TabPage3 extends StatefulWidget {
  const TabPage3({Key? key}) : super(key: key);

  @override
  State<TabPage3> createState() => _TabPage3State();
}

class _TabPage3State extends State<TabPage3> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Center(),
      ),
    );
  }
}
