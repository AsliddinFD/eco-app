import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/utils/urls.dart';
import 'package:frontend/widgets/liked_widget.dart';
import 'package:http/http.dart' as http;

class LikedProducts extends StatefulWidget {
  const LikedProducts({super.key});
  @override
  State<LikedProducts> createState() {
    return _LikedProductsState();
  }
}

class _LikedProductsState extends State<LikedProducts> {
  List likedProducts = [];
  @override
  void initState() {
    getLikedProducts();
    super.initState();
  }

  getLikedProducts() async {
    final api =
        Uri.parse(likedProductsApi.replaceAll('user_id', userId.toString()));
    final response = await http.get(api, headers: {
      'Content-type': 'applicatoin/json',
      'Authorization': 'Token $token'
    });
    if (response.statusCode == 200) {
      setState(() {
        likedProducts = json.decode(response.body);
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userId == null
          ? const Center(
              child: Text('Please, log in  to see the favourite products'),
            )
          : likedProducts.isEmpty
              ? const Center(
                  child: Text('You have no favourite products, yet!'),
                )
              : ListView.builder(
                  itemCount: likedProducts.length,
                  itemBuilder: (context, index) => LikedPorduct(
                    product: likedProducts[index],
                    getLikedProduct: getLikedProducts(),
                  ),
                ),
    );
  }
}
