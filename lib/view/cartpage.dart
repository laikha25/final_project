import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab3/model/config.dart';
import 'package:lab3/model/user.dart';
import 'package:http/http.dart' as http;

import 'checkout.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String titlecenter = "Loading data...";
  List cartlist = [];
  int scrollcount = 10;
  int numprd = 0;
  int rowcount = 2;
  double totalAmount = 0.0;
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Total: RM " + totalAmount.toStringAsFixed(2),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () {
                _checkoutPay();
              },
              child: const Text('CHECKOUT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      )),
      body: cartlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 35, 5, 0),
                    child: Text("My Cart",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cartlist.length,
                        // controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(left: 18),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen.shade100,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Text(
                                        cartlist[index]['prname'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        "hiii",
                                        style: TextStyle(
                                            color: Colors.transparent),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "RM " +
                                              cartlist[index]['totalprice']
                                                  .toStringAsFixed(2),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 17),
                                    onPressed: () {
                                      modifyQty(index, "removecart");
                                    },
                                  ),
                                  Text(cartlist[index]['cart_qty']),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 17),
                                    onPressed: () {
                                      modifyQty(index, "addcart");
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      _delCart(index);
                                    },
                                  ),
                                ]),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }

  _loadCart() {
    if (widget.user.email == "na") {
      setState(() {
        titlecenter = "Unregistered User";
      });
      return;
    }
    http.post(Uri.parse(Config.server + "/php/load_cart.php"), body: {
      "id": widget.user.id,
      "user_email": widget.user.email
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        setState(() {
          cartlist = extractdata["cart"];
          numprd = cartlist.length;
          if (scrollcount >= cartlist.length) {
            scrollcount = cartlist.length;
          }
          totalAmount = 0.0;
          for (int i = 0; i < cartlist.length; i++) {
            totalAmount = totalAmount +
                double.parse(cartlist[i]['prprice']) *
                    int.parse(cartlist[i]['cart_qty']);
          }
        });
      } else {
        setState(() {
          titlecenter = "No food in your cart";
        });
      }
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (cartlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= cartlist.length) {
            scrollcount = cartlist.length;
          }
        }
      });
    }
  }

  Future<void> modifyQty(int index, String s) async {
    await Future.delayed(Duration(seconds: 1));
    http.post(Uri.parse(Config.server + "/php/update_cart.php"), body: {
      "user_email": widget.user.email,
      "op": s,
      "prid": cartlist[index]['prid'],
      "cart_qty": cartlist[index]['cart_qty'],
    }).then((response) {
      if (response.body == "success") {
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<void> _delItemCart(int index) async {
    await Future.delayed(Duration(seconds: 1));
    http.post(Uri.parse(Config.server + "/php/delete_cart.php"), body: {
      "user_email": widget.user.email,
      "prid": cartlist[index]['prid']
    }).then((response) {
      if (response.body == "success") {
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _delCart(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Delete this menu",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _delItemCart(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkoutPay() {
    if (totalAmount != 0.0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Proceed to Checkout",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        user: widget.user,
                        totalAmt: totalAmount,
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Amount not payable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
