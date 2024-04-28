import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:quran_tracing/models/products_model.dart';
import 'package:quran_tracing/widgets/products_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  final String type;

  const ProductList({Key? key, required this.type}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late final PagingController<int, Product> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchProducts(pageKey);
    });
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchProducts(int pageKey) async {
    try {
      var url = Uri.http("quronhusnixati.uz:4000", "/product/all", {
        "page": "$pageKey",
        "limit": "10",
        "type": widget.type,
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final productsModel = ProductsModel.fromJson(jsonDecode(response.body));
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(productsModel.products, nextPageKey);
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  void _deleteProduct(String id) async {
    String? token = await getToken();
    try {
      final http.Response response = await http.delete(
        Uri.parse('http://quronhusnixati.uz:4000/product/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token!,
        },
      );

      if (response.statusCode == 200) {
        // Item deleted successfully
        print('Item deleted successfully');
        setState(() {
          _pagingController.itemList
              ?.removeWhere((product) => product.id == id);
        });
      } else if (response.statusCode == 204) {
        // No content returned from the server
        print('No content returned from the server');
      } else {
        // Handle other status codes
        throw Exception(
            'Failed to delete item. Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting item: $e');
      throw Exception('Failed to delete item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagedListView<int, Product>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, item, index) => ProductItem(
            product: item,
            onDelete: () {
              _deleteProduct(item.id!);
            },
          ),
        ),
        separatorBuilder: (ctx, index) => const Divider(),
      ),
    );
  }
}
