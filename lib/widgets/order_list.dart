import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quran_tracing/models/orders_model.dart';
import 'package:quran_tracing/widgets/order_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

class OrdersList extends StatefulWidget {
  const OrdersList({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _OrdersListState();
  }
}

class _OrdersListState extends State<OrdersList> {
  late final PagingController<int, Order> _pagingController;

  @override
  void initState() {
    super.initState();

    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchOrders(pageKey);
    });
  }

  Future<void> _fetchOrders(int pageKey) async {
    try {
      var url = Uri.http("quronhusnixati.uz:4000", "/order/all", {
        "page": "$pageKey",
        "limit": "10",
        "status": widget.title,
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final ordersModel = OrdersModel.fromJson(jsonDecode(response.body));

        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(ordersModel.orders, nextPageKey);
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedGridView<int, Order>(
        pagingController: _pagingController,
        showNewPageProgressIndicatorAsGridChild: true,
        showNewPageErrorIndicatorAsGridChild: true,
        showNoMoreItemsIndicatorAsGridChild: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        builderDelegate: PagedChildBuilderDelegate<Order>(
          itemBuilder: (context, order, index) {
            return OrderItem(order: order);
          },
        ),
      ),
    );
  }
}
