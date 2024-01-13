import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getProducts = FutureProvider<List<dynamic>>(
  (ref) async {
    final api = Uri.parse(productsApi);
    final response = await http.get(api);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  },
);
