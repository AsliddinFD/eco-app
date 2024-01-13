import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProviderNotifier extends StateNotifier<bool> {
  ThemeProviderNotifier() : super(false);
  bool toggleTheme() {
    state = !state;
    return state;
  }
}

final themeProvider = StateNotifierProvider<ThemeProviderNotifier, bool>(
  (ref) => ThemeProviderNotifier(),
);
