import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quran_tracing/models/users_model.dart';
import 'package:quran_tracing/widgets/user_item.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsersScreen extends StatefulWidget {
  final String title;

  const UsersScreen({super.key, required this.title});
  @override
  State<StatefulWidget> createState() {
    return _UsersScreenState();
  }
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class _UsersScreenState extends State<UsersScreen> {
  late final PagingController<int, User> _pagingController;

  @override
  void initState() {
    super.initState();

    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchOrders(pageKey);
    });
  }

  Future<void> _fetchOrders(int pageKey) async {
    String? token = await getToken();
    try {
      var url = Uri.http("quronhusnixati.uz:4000", "/user/all", {
        "page": "$pageKey",
        "limit": "10",
      });

      final response = await http.get(url, headers: {'Authorization': token!});

      if (response.statusCode == 200) {
        final users = UsersModel.fromJson(jsonDecode(response.body));

        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(users.users, nextPageKey);
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, User>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<User>(
              itemBuilder: (context, item, index) => UserItem(
                    color: Colors.blue,
                    user: item,
                  )),
        ),
      ),
    );
  }
}
