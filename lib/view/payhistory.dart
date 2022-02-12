import 'package:flutter/material.dart';
import 'package:lab3/model/user.dart';

class PayHistory extends StatefulWidget {
  final User user;
  const PayHistory({Key? key, required this.user}) : super(key: key);

  @override
  State<PayHistory> createState() => _PayHistoryState();
}

class _PayHistoryState extends State<PayHistory> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
