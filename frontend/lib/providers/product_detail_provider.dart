import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getProductDetails(id) async {
  final api = Uri.parse(
    productDetailApi.replaceAll('id', id.toString()),
  );

  final response = await http.get(api);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print(response.body);
    return json.decode(response.body);
  }
}

final productDetailProvider = FutureProvider.autoDispose.family(
  (ref, String productId) => getProductDetails(productId),
);
