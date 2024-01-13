import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getCartProvider(String userId) async {
  final api = Uri.parse(getCartApi.replaceAll('userId', userId.toString()));
  final response =
      await http.get(api, headers: {'Authorization': 'Token $token'});
  if (response.statusCode == 200) {
    var responseData = [];
    responseData = json.decode(response.body);
    return responseData;
  } else {
    print(response.body);
    throw Exception('Failed to fetch cart');
  }
}

Future<String> addCartProvider(String productId) async {
  final api = Uri.parse(addCartApi);
  final response = await http.post(
    api,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Token $token'
    },
    body: json.encode({
      'user': userId,
      'product': productId,
    }),
  );
  if (response.statusCode == 201) {
    print(response.body);
    return json.decode(response.body);
  } else {
    final msg = json.decode(response.body);
    print(msg);
    throw Exception('Failed to add item to cart');
  }
}

Future<String> updateCartProvider(String productId) async {
  final api =
      Uri.parse(updateCartApi.replaceAll('productId', productId.toString()));
  final response = await http.put(
    api,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Token $token'
    },
  );
  if (response.statusCode == 200 || response.statusCode == 204) {
    print(json.decode(response.body));
    return token;
  } else {
    print(json.decode(response.body));
    throw Exception('Failed to update cart');
  }
}

Future<String> deleteCart(String cartId) async {
  final api = Uri.parse(deleteCartApi.replaceAll('cartId', cartId.toString()));
  final response = await http.delete(
    api,
    headers: {'Authorization': 'Token $token'},
  );
  print(response.body);

  if (response.statusCode == 200) {
    print(response.body);
    return json.decode(response.body);
  } else {
    return '';
  }
}

final getCartProviderFuture = FutureProvider.autoDispose.family(
  (ref, String userId) => getCartProvider(userId),
);

final addToCartProviderFuture = FutureProvider.autoDispose.family(
  (ref, String productId) => addCartProvider(productId),
);

final updateCartProviderFuture = FutureProvider.autoDispose.family(
  (ref, String productId) => updateCartProvider(productId),
);

final deleteCartProviderFuture = FutureProvider.autoDispose.family(
  (ref, String cartId) => deleteCart(cartId),
);
