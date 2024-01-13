import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/order_details.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/urls.dart';

class OrdersItem extends StatelessWidget {
  const OrdersItem({
    super.key,
    required this.productId,
    required this.price,
    required this.orderedDate,
    required this.count,
    required this.orderId,
    required this.cancelOrder,
  });
  final String productId;
  final String price;
  final String orderedDate;
  final int count;
  final int orderId;
  final void Function(int) cancelOrder;
  

  Future<dynamic> getProduct(String productId) async {
    final api = Uri.parse(productDetailApi.replaceAll('id', productId));
    final response = await http.get(api);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProduct(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          dynamic product = snapshot.data['product'];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetail(
                    product: product,
                    count: count,
                    orderId: orderId,
                    cancelOrder: cancelOrder,
                  ),
                ),
              );
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Name: '),
                        Text(product['name']),
                        const SizedBox(height: 10),
                        const Text('Price: '),
                        Text(price),
                        const SizedBox(height: 10),
                        const Text('Ordered Date: '),
                        Text(orderedDate),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Problem occured. Please try again later'),
          );
        }
      },
    );
  }
}
