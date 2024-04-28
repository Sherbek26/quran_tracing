import 'package:flutter/material.dart';
import 'package:quran_tracing/widgets/login_inputField.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Husnixat.uz',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          const LoginInputField(),
        ],
      ),
    );
  }
}
