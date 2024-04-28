import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quran_tracing/models/logIn_model.dart';
import 'package:quran_tracing/screens/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import TabScreen

class LoginInputField extends StatefulWidget {
  const LoginInputField({Key? key}) : super(key: key);

  @override
  State<LoginInputField> createState() => _LoginInputFieldState();
}

Future<LogInModel> postLogIn(String phoneNumber, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://quronhusnixati.uz:4000/admin/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'phoneNumber': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      return LogInModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to log in. Server responded with status code ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions that occur during the request
    print('Error during login request: $e');
    throw Exception('Failed to log in: $e');
  }
}

class _LoginInputFieldState extends State<LoginInputField> {
  final _formKey = GlobalKey<FormState>();
  late String phoneNumber;
  late String password;
  Future<LogInModel>? _futureLogIn;

  @override
  void initState() {
    super.initState();
    checkAndNavigate();
  }

  Future<void> checkAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? tokenTimestamp = prefs.getString('tokenTimestamp');

    if (token != null && tokenTimestamp != null) {
      DateTime tokenTime = DateTime.parse(tokenTimestamp);
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(tokenTime);

      if (difference.inHours < 24) {
        // Token is valid, navigate to main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TabScreen(),
          ),
        );
      }
    }
  }

  Future<void> setToken(String token, String firstName, String lastName,
      String id, bool isActive) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('firstName', firstName);
    prefs.setString('lastName', lastName);
    prefs.setString('id', id);
    prefs.setBool('isActive', isActive);

    prefs.setString('tokenTimestamp', DateTime.now().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogin() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        try {
          // Set the future to the result of postLogIn
          setState(() {
            _futureLogIn = postLogIn(phoneNumber, password);
          });

          final loggedInUser = await _futureLogIn;
          if (loggedInUser != null) {
            // Set token if login is successful
            await setToken(
                loggedInUser.token,
                loggedInUser.admin.firstName,
                loggedInUser.admin.lastName,
                loggedInUser.admin.id,
                loggedInUser.admin.isActive);

            // Navigate to TabScreen if login is successful
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const TabScreen(),
              ),
            );
          } else {
            // Handle null loggedInUser
          }
        } catch (error) {
          // Handle login error and show dialog
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 28,
                ),
                title: Text(
                  'Login Failed',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                content: Text(
                  "Telefon raqami yoki parolingiz xato, qaytadan urinib ko'ring!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Telefon raqam'),
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return "Iltimos, avval to'ldiring";
                }
                return null;
              },
              maxLength: 13,
              onSaved: (newValue) => phoneNumber = newValue!,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Parol'),
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return "Iltimos, avval to'ldiring";
                }
                return null;
              },
              maxLength: 25,
              onSaved: (newValue) => password = newValue!,
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: handleLogin,
              child: Text(
                'Log in',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
