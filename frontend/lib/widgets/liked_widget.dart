import 'package:flutter/material.dart';
import 'package:frontend/screens/product_details.dart';

class LikedPorduct extends StatelessWidget {
  const LikedPorduct({
    super.key,
    required this.product,
    required this.getLikedProduct,
  });
  final dynamic product;
  final dynamic getLikedProduct;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(
                id: product['id'],
              ),
            ),
          );
          getLikedProduct();
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                product['images'].split(' ')[0],
                width: 100,
                height: 150,
              ),
              const SizedBox(width: 10),
              Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
