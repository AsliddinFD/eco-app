import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/input_style_provider.dart';
import 'package:frontend/providers/register_provider.dart';
import 'package:frontend/screens/login.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: ref
                    .read(inputStyleProvider.notifier)
                    .customInputStyle('Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: ref
                    .read(inputStyleProvider.notifier)
                    .customInputStyle('Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: ref
                    .read(inputStyleProvider.notifier)
                    .customInputStyle('Password'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordConfirmController,
                decoration: ref
                    .read(inputStyleProvider.notifier)
                    .customInputStyle('Comfirm password'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(registerProvider.notifier).register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _passwordConfirmController.text,
                        context,
                        ref,
                      );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Have an account? Login!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
