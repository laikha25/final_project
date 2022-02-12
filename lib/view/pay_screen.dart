import 'dart:async';
import 'package:lab3/model/config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lab3/model/user.dart';

class PayScreen extends StatefulWidget {
  final User user;
  final double totalAmount;
  const PayScreen({Key? key, required this.user, required this.totalAmount})
      : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: WebView(
                initialUrl: Config.server +
                    '/php/generate_bill.php?email=' +
                    widget.user.email.toString() +
                    '&phone=' +
                    widget.user.phone.toString() +
                    '&name=' +
                    widget.user.name.toString() +
                    '&amount=' +
                    widget.totalAmount.toStringAsFixed(2),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
