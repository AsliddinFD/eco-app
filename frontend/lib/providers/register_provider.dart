import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/tabs.dart';
import 'package:frontend/utils/functions.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterStateNotifer extends StateNotifier {
  RegisterStateNotifer() : super('');

  void register(name, email, password, passwordConfirm, context, ref) async {
    if (password != passwordConfirm) {
      showCupertinoDialog(
        context: (context),
        builder: (context) => CupertinoAlertDialog(
          content: const Text('The passwords should match!'),
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
    } else if (email.isEmpty || password.isEmpty || name.isEmpty) {
      showCupertinoDialog(
        context: (context),
        builder: (context) => CupertinoAlertDialog(
          content: const Text('Fill all the fields!'),
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
    } else {
      final api = Uri.parse(registerApi);
      final response = await http.post(
        api,
        headers: {'Content-type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        token = json.decode(response.body)['token'];
        getUserInfo();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TabsScreen(),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        final msg = responseData.values.toList()[0][0];
        print(msg);
      }
    }
  }
}

final registerProvider = StateNotifierProvider<RegisterStateNotifer, dynamic>(
  (ref) => RegisterStateNotifer(),
);
