import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quran_tracing/models/created_product_model.dart';
import 'package:quran_tracing/screens/new_product.dart';
import 'package:quran_tracing/widgets/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool transitioning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration(seconds: 1),
    )..addListener(_handleTabIndexChanged);
  }

  void _handleTabIndexChanged() {
    setState(() {
      transitioning = _tabController.indexIsChanging;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<CreatedProduct> postProduct(CreatedProduct createdProduct) async {
    String? token = await getToken();
    try {
      final response = await http.post(
        Uri.parse('http://quronhusnixati.uz:4000/product/create'),
        headers: {
          "Authorization": token!,
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          <String, dynamic>{
            'name': createdProduct.name,
            'price': createdProduct.price, // Ensure price is an int
            'image': createdProduct.image,
            'type': createdProduct.type
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreatedProduct.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // Print server response if available
        print('Server error: ${response.body}');
        throw Exception(
            'Failed to create product. Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error creating product: $e');
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (ctx) => NewProduct(
                  // Callback function to add the new product to the API
                  onAddProduct: postProduct,
                ),
              );
            },
            icon: const Icon(Icons.add_outlined),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: "Barchasi",
              icon: Icon(Icons.sell_rounded),
            ),
            Tab(
              text: "Oddiy",
              icon: Icon(Icons.circle_rounded),
            ),
            Tab(
              text: "Maxsus",
              icon: Icon(Icons.star_rounded),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProductList(type: ""),
          ProductList(type: "usual"),
          ProductList(type: "special"),
        ],
      ),
    );
  }
}
