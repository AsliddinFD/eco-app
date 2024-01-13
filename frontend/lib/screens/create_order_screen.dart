import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/urls.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/utils/functions.dart';

class CreateOrdersScreen extends StatefulWidget {
  const CreateOrdersScreen({
    super.key,
    required this.product,
    required this.cartCount,
    required this.deleteCart,
    required this.cartId,
  });
  final dynamic product;
  final int cartCount;
  final int cartId;
  final void Function(int) deleteCart;
  @override
  State<CreateOrdersScreen> createState() {
    return _CreateOrdersScreen();
  }
}

class _CreateOrdersScreen extends State<CreateOrdersScreen> {
  bool isLoading = false;
  void createOrder(price) async {
    if (userId == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      final api = Uri.parse(
        createOrderApi.replaceAll('userId', userId.toString()),
      );
      final response = await http.post(
        api,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Token $token'
        },
        body: json.encode({
          'product': widget.product['id'],
          'user': userId,
          'count': widget.cartCount,
          'price': price,
        }),
      );
      if (response.statusCode == 201 && context.mounted) {
        setState(() {
          isLoading = true;
        });
        widget.deleteCart(widget.cartId);
        
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            content: Text('Your order has been created'),
          ),
        );
      } else {
        print(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final overallPrice =
        double.parse(widget.product['price'].toString()).toInt() *
            double.parse(widget.cartCount.toString()).toInt();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Image.network(
              widget.product['images'].split(' ')[0],
              height: 300,
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Text('Price'),
              trailing:
                  Text('\$${double.parse(widget.product['price']).toInt()}'),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Text('Added amount'),
              trailing: Text('${widget.cartCount}'),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Text('Overall price'),
              trailing: Text(
                formatThePrice(double.parse(overallPrice.toString()))
                    .toString(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                createOrder(overallPrice);
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(double.infinity, 50)),
              child: !isLoading
                  ? const Text('Order')
                  : const CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
