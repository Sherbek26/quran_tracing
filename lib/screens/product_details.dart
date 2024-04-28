import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quran_tracing/models/product_detail_model.dart';
import 'package:quran_tracing/widgets/token.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
      {super.key, required this.productId, required this.productName});
  final String productId;
  final String productName;
  @override
  State<StatefulWidget> createState() {
    return _ProductDetailScreenState();
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<ProductDetailsModel> futureProductDetails;

  Future<ProductDetailsModel> fetchProductDetails(String productId) async {
    var url = Uri.http("quronhusnixati.uz:4000", "product/$productId");
    final response = await http.get(url, headers: {"Authorization": token});
    if (response.statusCode == 200) {
      return ProductDetailsModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw (Exception('Fales'));
    }
  }

  @override
  void initState() {
    futureProductDetails = fetchProductDetails(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<ProductDetailsModel>(
          future: futureProductDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // final product = snapshot.data!;
              return Column(
                children: [
                  FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: AssetImage("assets/images/login_image.png"),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
