import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab3/model/config.dart';
import 'package:lab3/model/product.dart';
import 'package:lab3/model/user.dart';
import 'package:lab3/view/newproduct.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:lab3/view/prodetailspage.dart';

class TabPage1 extends StatefulWidget {
  final User user;
  const TabPage1({Key? key, required this.user}) : super(key: key);

  @override
  _TabPage1State createState() => _TabPage1State();
}

class _TabPage1State extends State<TabPage1> {
  List productlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int numprd = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadProducts();
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
        body: productlist.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 35, 5, 0),
                    child: Text("Menu Ina Maju",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowcount,
                      controller: _scrollController,
                      children: List.generate(scrollcount, (index) {
                        return Card(
                            child: InkWell(
                          onTap: () => {_prodDetails(index)},
                          child: Column(
                            children: [
                              Flexible(
                                flex: 4,
                                child: CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl: Config.server +
                                      "/images/products/" +
                                      productlist[index]['prid'] +
                                      ".png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            truncateString(productlist[index]
                                                    ['prname']
                                                .toString()),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.04,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "RM " +
                                                double.parse(productlist[index]
                                                        ['prprice'])
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: resWidth * 0.03,
                                            )),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(screenWidth / 4,
                                                screenHeight / 200),
                                          ),
                                          child: const Text(
                                            'Add to Cart',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          onPressed: () =>
                                              {_addCartDialog(index)},
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ));
                      }),
                    ),
                  ),
                ],
              ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.add),
                label: "New Product",
                labelStyle: const TextStyle(color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: _newProduct),
          ],
        ));
  }

  // int loadPages(int prlist) {
  //   int itemperpage = 10;
  //   if (prlist <= 10) {
  //     return prlist;
  //   }

  // }

  String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (productlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        }
      });
    }
    // if (_scrollController.offset <=
    //         _scrollController.position.minScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   setState(() {
    //     message = "reach the top";
    //   });
    // }
  }

  Future<void> _newProduct() async {
    if (widget.user.email != "inamaju@gmail.com") {
      Fluttertoast.showToast(
          msg: "Only seller can use this feature",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0);
      return;
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NewProduct(user: widget.user)));
    productlist = [];
    _loadProducts();
  }

  _loadProducts() {
    if (widget.user.email == "na") {
      setState(() {
        titlecenter = "Unregistered User";
      });
      return;
    }
    http.post(Uri.parse(Config.server + "/php/load_product.php"),
        body: {"id": widget.user.id}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          numprd = productlist.length;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  _prodDetails(int index) async {
    Product product = Product(
      prid: productlist[index]['prid'],
      prname: productlist[index]['prname'],
      prdesc: productlist[index]['prdesc'],
      prprice: productlist[index]['prprice'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailsPage(
                  product: product,
                )));
  }

  _addCartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add this menu to your cart",
            style: TextStyle(),
          ),
          content: Text(productlist[index]['prname'].toString(),
              style: const TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addcart(index);
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

  void _addcart(int index) {
    String prid = productlist[index]['prid'].toString();
    String cartqty = 1.toString();
    String userEmail = widget.user.email.toString();

    http.post(Uri.parse(Config.server + "/php/addtocart.php"), body: {
      "user_email": userEmail,
      "prid": prid,
      "qty": cartqty,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          data['status'] == 'success' &&
          userEmail != "inamaju@gmail.com") {
        Fluttertoast.showToast(
            msg: "Successfully added to your cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed as you are the seller",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
