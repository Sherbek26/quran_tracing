import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_tracing/models/admins_model.dart';
import 'package:http/http.dart' as http;
import 'package:quran_tracing/screens/log_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDetail extends StatefulWidget {
  const AdminDetail({super.key, required this.title, required this.id});
  final String title;
  final String id;
  @override
  State<StatefulWidget> createState() {
    return _AdminDetailState();
  }
}

class _AdminDetailState extends State<AdminDetail> {
  late Future<Admin> _futureAdminDetail;

  Future<Admin> fetchAdminDetail(String adminId) async {
    var url =
        Uri.http("quronhusnixati.uz:4000", "/admin/$adminId"); // Corrected URL
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Admin.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load admin details');
    }
  }

  @override
  void initState() {
    _futureAdminDetail = fetchAdminDetail(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Admin>(
      future: _futureAdminDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.grey, // Placeholder color
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.red, // Error color
            ),
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          final admin = snapshot.data!;
          Color appBarColor = admin.isActive!
              ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
              : Color.fromARGB(170, 158, 158, 158);
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                backgroundColor: appBarColor,
              ),
              body: Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        admin.role == 'admin'
                            ? "Admin ma'lumotlari:"
                            : "Egasi ma'lumotlari",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To'liq ismi",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            "${admin.firstName}  ${admin.lastName}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Telefon raqami: ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            admin.phoneNumber!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mail: ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            admin.email!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shaxsiy Id:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            admin.id!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(appBarColor),
                        ),
                        onPressed: () {
                          logout(context);
                        },
                        child: Text(
                          "Log out",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        }
      },
    );
  }
}

void logout(BuildContext context) async {
  // Delete token and all other relevant data from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  // Add other data removals if needed

  // Navigate back to the login screen
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LogInScreen()),
    (route) => false,
  );
}
