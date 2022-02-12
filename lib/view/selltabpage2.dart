import 'package:flutter/material.dart';
import 'package:lab3/model/user.dart';
import 'package:lab3/view/mainpage.dart';
import 'package:lab3/view/myaccount.dart';

class SellTabPage2 extends StatefulWidget {
  final User user;
  const SellTabPage2({Key? key, required this.user}) : super(key: key);

  @override
  State<SellTabPage2> createState() => _SellTabPage2State();
}

class _SellTabPage2State extends State<SellTabPage2> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Flexible(
          flex: 6,
          child: Card(
            elevation: 10,
            color: Colors.cyan[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 64.0,
                            left: 32.0,
                            right: 32.0,
                            bottom: 15.0,
                          ),
                          child: Container(
                            height: 150.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(150.0),
                              image: const DecorationImage(
                                  image:
                                      AssetImage("assets/images/profile.jpeg"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "SELLER",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Malay Cuisine",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.normal),
                        ),
                        const Text(
                          "space",
                          style:
                              TextStyle(fontSize: 9, color: Colors.transparent),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              Icons.thumb_up_rounded,
                              color: Colors.amber,
                            ),
                            Text(
                              "  65 Points",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            Text(
                              " | ",
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.attach_money_rounded,
                              color: Colors.green,
                            ),
                            Text(
                              "RM 34.90",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 5),
              child: Column(
                children: [
                  const Center(
                    child: Text("SETTINGS",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Expanded(
                      child: ListView(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          shrinkWrap: true,
                          children: [
                        const MaterialButton(
                          onPressed: null,
                          child: Text("Edit Business Profile"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MyAccount(user: widget.user)));
                          },
                          child: Text("My Account"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const MaterialButton(
                          onPressed: null,
                          child: Text("Subscription"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const MaterialButton(
                          onPressed: null,
                          child: Text("Help Centre"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          onPressed: _logoutDialog,
                          child: const Text(
                            "LOG OUT",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const Divider(
                          height: 2,
                        ),
                      ])),
                ],
              ),
            )),
      ],
    ));
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Log Out ",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                widget.user.email = "na";
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainPage(
                              user: widget.user,
                            )));
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
}
