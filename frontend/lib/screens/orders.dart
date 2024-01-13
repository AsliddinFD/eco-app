import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/utils/urls.dart';
import 'package:frontend/widgets/orders_item.dart';
import 'package:http/http.dart' as http;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() {
    return _OrdersScreen();
  }
}

class _OrdersScreen extends State<OrdersScreen> {
  dynamic responseData;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  void getOrders() async {
    final api = Uri.parse(ordersApi.replaceAll('userId', userId.toString()));
    final response = await http.get(
      api,
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      setState(() {
        responseData = decodedResponse;
      });
      print(responseData);
    } else {
      print(response.body);
    }
  }

  void deleteOrder(orderId) async {
    final api = Uri.parse(
      cancelOrderApi.replaceAll('id', orderId.toString()),
    );
    final response = await http.delete(api, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Token $token'
    });
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: userId == null
          ? const Center(
              child: Text('Please, log in to see your purchase'),
            )
          : responseData == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : responseData.isEmpty
                  ? const Center(
                      child: Text('You have no any purchase'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: responseData.length,
                        itemBuilder: (context, index) => OrdersItem(
                          productId: responseData[index]['product'].toString(),
                          price: responseData[index]['price'],
                          orderedDate: responseData[index]['date'],
                          count: responseData[index]['count'],
                          orderId: responseData[index]['id'],
                          cancelOrder: deleteOrder,
                        ),
                      ),
                    ),
    );
  }
}
