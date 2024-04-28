import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_tracing/screens/admin_detail.dart';
import 'package:quran_tracing/screens/admins.dart';
import 'package:quran_tracing/screens/orders.dart';
import 'package:quran_tracing/screens/products.dart';
import 'package:quran_tracing/screens/statistics.dart';
import 'package:quran_tracing/screens/users.dart';
import 'package:quran_tracing/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getFirstName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('firstName');
}

Future<String?> getLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastName');
}

Future<String?> getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('id');
}

Future<bool?> getIsActive() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isActive');
}

class TabScreen extends StatefulWidget {
  const TabScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  String? firstName;
  String? lastName;
  String? id;
  bool? isActive;

  @override
  void initState() {
    super.initState();
    // Fetch data from SharedPreferences when the widget is initialized
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Fetch all necessary user data
    firstName = await getFirstName();
    lastName = await getLastName();
    id = await getId();
    isActive = await getIsActive();
    // Notify the widget that state has changed so it rebuilds with the fetched data
  }

  void navigatingScreen(Widget screen) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => screen));
  }

  @override
  Widget build(BuildContext context) {
    var activePageTitle = "Statistika";
    Widget activePage = const StatisticScreen();
    void setScreen(String identifier) {
      if (identifier == 'products') {
        activePageTitle = "Maxsulotlar";
        navigatingScreen(
          ProductsScreen(
            title: activePageTitle,
          ),
        );
      } else if (identifier == 'orders') {
        activePageTitle = "Buyurtmalar";
        navigatingScreen(OrdersScreen(title: activePageTitle));
      } else if (identifier == 'users') {
        activePageTitle = "Foydalanuvchilar";
        navigatingScreen(UsersScreen(
          title: activePageTitle,
        ));
      } else if (identifier == 'admins') {
        activePageTitle = "Adminlar";
        navigatingScreen(AdminsScreen(title: activePageTitle));
      } else if (identifier == 'admin') {
        navigatingScreen(AdminDetail(
          title: "$firstName  $lastName",
          id: id == null ? "" : id!,
        ));
      } else {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      drawer: MainDrawer(
        onSelectScreen: setScreen,
      ),
    );
  }
}
