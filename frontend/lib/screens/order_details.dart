import 'package:flutter/material.dart';
import 'package:frontend/utils/functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class OrderDetail extends ConsumerStatefulWidget {
  const OrderDetail({
    super.key,
    required this.product,
    required this.count,
    required this.cancelOrder,
    required this.orderId,
  });
  final dynamic product;
  final int count;
  final void Function(int) cancelOrder;
  final int orderId;

  @override
  ConsumerState<OrderDetail> createState() {
    return _OrderDetailState();
  }
}

class _OrderDetailState extends ConsumerState<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    final overallPrice =
        double.parse(widget.product['price'].toString()).toInt() *
            double.parse(widget.count.toString()).toInt();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Image.network(widget.product['images'].split(' ')[0]),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Product price'),
              trailing: Text('\$${widget.product['price']}'),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Purchased amount'),
              trailing: Text(widget.count.toString()),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Overall paid price'),
              trailing: Text(formatThePrice(double.parse(overallPrice.toString()))
                  .toString()),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.cancelOrder(widget.orderId);
                    },
                    child: const Text('Cancel'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
