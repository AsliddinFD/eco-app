import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/cart_notifier.dart';
import 'package:frontend/screens/create_order_screen.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/urls.dart';

class CartItem extends ConsumerStatefulWidget {
  const CartItem({
    super.key,
    required this.productId,
    required this.cart,
    required this.deleteCart,
    
  });

  final int productId;
  final dynamic cart;
  final void Function(int) deleteCart;
  

  @override
  ConsumerState<CartItem> createState() {
    return _CarItemState();
  }
}

class _CarItemState extends ConsumerState<CartItem> {
  @override
  void initState() {
    super.initState();
    count = widget.cart['count'];
    getProductDetails(widget.productId);
  }

  late int count;
  dynamic product;
  dynamic mainContent;

  increaseCart(userId, productId) async {
    final api = Uri.parse(addCartApi);
    final response = await http.post(
      api,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Token $token'
      },
      body: json.encode(
        {
          'user': userId,
          'product': productId,
        },
      ),
    );
    if (response.statusCode == 201) {
      print(response.body);
    } else {
      final msg = json.decode(response.body);
      print(msg);
    }
  }

  decreaseCart(productId) async {
    final api = Uri.parse(
      updateCartApi.replaceAll('productId', productId.toString()),
    );
    final response = await http.put(
      api,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      print(json.decode(response.body));
    } else {
      print(json.decode(response.body));
    }
  }

  void getProductDetails(id) async {
    final api = Uri.parse(
      productDetailApi.replaceAll('id', id.toString()),
    );
    final response = await http.get(api);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        product = responseData['product'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const CircularProgressIndicator()
        : InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateOrdersScreen(
                    product: product,
                    cartCount: count,
                    cartId: widget.cart['id'],
                    deleteCart: widget.deleteCart,
                  ),
                ),
              );
              setState(() {
                ref.watch(getCartProviderFuture(userId.toString()));
              });
            },
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Row(
                  children: [
                    Image.network(
                      product['images'].split(' ')[0],
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name']),
                          Text('\$${double.parse(product['price']).toInt()}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (count == 1) {
                            widget.deleteCart(widget.cart['id']);
                          } else {
                            count--;
                            
                          }
                        });
                        decreaseCart(product['id']);
                      },
                      icon: const Icon(CupertinoIcons.minus),
                    ),
                    Text('$count'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          count++;
                          
                        });
                        increaseCart(userId, product['id']);
                      },
                      icon: const Icon(CupertinoIcons.add),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
