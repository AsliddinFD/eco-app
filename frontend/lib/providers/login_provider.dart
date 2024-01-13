import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/tabs.dart';
import 'package:frontend/utils/functions.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifier extends StateNotifier<String> {
  LoginNotifier() : super('');

  void login(email, password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      showCupertinoDialog(
        context: (context),
        builder: (context) => CupertinoAlertDialog(
          content: const Text('Fill out all the fields'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      final api = Uri.parse(loginApi);
      final response = await http.post(
        api,
        headers: {'Content-type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 && context.mounted) {
        token = json.decode(response.body)['token'];
        getUserInfo();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TabsScreen(),
          ),
        );
      } else if (context.mounted) {
        final responseData = json.decode(response.body);
        final msg = responseData.values.toList();
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text(msg[0][0]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, String>(
  (ref) {
    return LoginNotifier();
  },
);
