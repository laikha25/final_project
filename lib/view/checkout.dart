import 'package:flutter/material.dart';
import 'package:lab3/model/user.dart';
import 'package:lab3/view/pay_screen.dart';

class CheckoutPage extends StatefulWidget {
  final User user;
  final double totalAmt;
  const CheckoutPage({Key? key, required this.user, required this.totalAmt})
      : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Checkout'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
            flex: 7,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 5),
                child: Column(
                  children: [
                    const Text("CUSTOMER DETAILS",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text(""),
                    Table(
                      columnWidths: const {0: FractionColumnWidth(.35)},
                      children: [
                        TableRow(children: [
                          const Text("Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(widget.user.name.toString(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ]),
                        TableRow(children: [
                          const Text("Contact No.",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(widget.user.phone.toString(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ]),
                      ],
                    ),
                    const Text(""),
                    const Text("Delivery Address",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Card(
                      elevation: 10,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          widget.user.address.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Text(""),
                    const Text(""),
                    const Text(""),
                    const Text("TOTAL PAYMENT",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      "RM " + widget.totalAmt.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    Container(
                      width: screenWidth / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          _proceedDialog();
                        },
                        child: const Text("PROCEED",
                            style: TextStyle(fontSize: 15)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                        ),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  void _proceedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Pay RM " + widget.totalAmt.toStringAsFixed(2),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Continue",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PayScreen(
                      user: widget.user,
                      totalAmount: widget.totalAmt,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
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
}
