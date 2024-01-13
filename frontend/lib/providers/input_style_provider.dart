import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomInputStyleNotifier extends StateNotifier<InputDecoration> {
  CustomInputStyleNotifier() : super(const InputDecoration());

  InputDecoration customInputStyle(String hintText) {
    return InputDecoration(
      hintText: hintText,
      labelText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }
}

final inputStyleProvider =
    StateNotifierProvider<CustomInputStyleNotifier, InputDecoration>(
  (ref) => CustomInputStyleNotifier(),
);
