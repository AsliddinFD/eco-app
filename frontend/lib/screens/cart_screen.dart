import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/urls.dart';
import 'package:frontend/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  var responseData = [];

  @override
  void initState() {
    super.initState();
    getCart(
      userId.toString(),
    );
  }

  void deleteCart(cartId) async {
    final api = Uri.parse(
      deleteCartApi.replaceAll('cartId', cartId.toString()),
    );
    final response = await http.delete(api, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Token $token'
    });

    if (response.statusCode == 204) {
      setState(() {
        getCart(
          userId.toString(),
        );
      });
    }
  }

  void getCart(String userId) async {
    final api = Uri.parse(getCartApi.replaceAll('userId', userId.toString()));
    final response =
        await http.get(api, headers: {'Authorization': 'Token $token'});
    if (response.statusCode == 200) {
      setState(() {
        responseData = json.decode(response.body);
      });
    } else {
      print(response.body);
      throw Exception('Failed to fetch cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userId == null
          ? const Center(
              child: Text('Please, log in to see your cart'),
            )
          : responseData.isEmpty
              ? const Center(
                  child: Text('You have not added any item to the cart.'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => CartItem(
                    productId: responseData[index]['product'],
                    cart: responseData[index],
                    deleteCart: deleteCart,
                  ),
                  itemCount: responseData.length,
                ),
    );
  }
}
