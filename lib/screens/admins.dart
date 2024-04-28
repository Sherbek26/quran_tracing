import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quran_tracing/models/admins_model.dart';
import 'package:http/http.dart' as http;
import 'package:quran_tracing/widgets/admin_item.dart';

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({super.key, required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _AdminsScreenState();
  }
}

class _AdminsScreenState extends State<AdminsScreen> {
  late final PagingController<int, Admin> _pagingController;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();

    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchAdmins(pageKey);
    });
  }

  Future<void> _fetchAdmins(int pageKey) async {
    try {
      var url = Uri.http("quronhusnixati.uz:4000", "/admin/all", {
        "page": "$pageKey",
        "limit": "10",
      });

      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        final admins = AdminsModel.fromJson(jsonDecode(response.body));

        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(admins.admins, nextPageKey);
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
        child: PagedListView<int, Admin>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Admin>(
              itemBuilder: (context, item, index) => AdminItem(
                    admin: item,
                  )),
        ),
      ),
    );
  }
}
