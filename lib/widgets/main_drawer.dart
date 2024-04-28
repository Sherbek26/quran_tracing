import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
    required this.onSelectScreen,
  }) : super(key: key);

  final void Function(String identifier) onSelectScreen;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

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

class _MainDrawerState extends State<MainDrawer> {
  bool isExpanded = false;

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

  void toggleDrawerExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
              ], begin: Alignment.bottomRight, end: Alignment.topLeft),
            ),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Icon(
                      FlutterIslamicIcons.quran2,
                      color: Theme.of(context).colorScheme.primary,
                      size: 52,
                    ),
                    const SizedBox(
                      width: 26,
                    ),
                    Text(
                      'Qu`ron' "\n" 'Husnixati',
                      style: GoogleFonts.molle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 22),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment
                    .bottomRight, // Align the additional icon to the bottom and start
                child: IconButton(
                  onPressed: toggleDrawerExpansion,
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 24,
                  ),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ]),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? 45 : 0, // Adjust the height when expanded
            child: ListTile(
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.4),
                child: Text(
                  firstName != null && firstName!.isNotEmpty
                      ? firstName![0]
                      : "",
                ),
              ),
              title: Text(
                "${firstName ?? ""} ${lastName ?? ""}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              trailing: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: isActive ?? false
                      ? const Color.fromARGB(167, 76, 175, 79)
                      : const Color.fromARGB(172, 158, 158, 158),
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                widget.onSelectScreen('admin');
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            leading: Icon(
              Icons.bar_chart_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text("Statistika",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16)),
            onTap: () {
              widget.onSelectScreen('statistics');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.storefront_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text('Maxsulotlar',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16)),
            onTap: () {
              widget.onSelectScreen('products');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text('Buyurtmalar',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16)),
            onTap: () {
              widget.onSelectScreen('orders');
            },
          ),
          CupertinoListTile(
            leading: Icon(
              Icons.people_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text('Foydalanuvchilar',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16)),
            onTap: () {
              widget.onSelectScreen('users');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shield_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text('Adminlar',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16)),
            onTap: () {
              widget.onSelectScreen('admins');
            },
          ),
        ],
      ),
    );
  }
}
