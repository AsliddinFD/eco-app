import 'dart:convert';

import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void getUserInfo() async {
  final api = Uri.parse(userInfoApi);
  final response =
      await http.get(api, headers: {'Authorization': 'Token $token'});

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print(responseData);
    userId = responseData['id'];
    email = responseData['email'];
    user_name = responseData['name'];
    print(userId);
  } else {
    print(response.body);
  }
}

String formatThePrice(double price) {
  String priceString = price.toString();
  List<String> priceParts = priceString.split('.');

  List<String> integerPart = priceParts[0].split('');
  for (var i = integerPart.length - 3; i > 0; i -= 3) {
    integerPart.insert(i, ',');
  }

  String formattedPrice = integerPart.join('');
  if (priceParts.length > 1) {
    formattedPrice += '.' + priceParts[1];
  }

  return '\$$formattedPrice';
}

String formatDateTimeString(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  // Format the date as "yyyy-MM-dd"
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

bool isOrdered = false;
