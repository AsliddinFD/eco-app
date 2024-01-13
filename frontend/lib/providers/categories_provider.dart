import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

final getCategories = FutureProvider<List<dynamic>>(
  (ref) async {
    final api = Uri.parse(categoriesApi);
    final response = await http.get(api);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories. Please check your network');
    }
  },
);
