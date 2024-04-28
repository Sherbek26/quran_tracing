import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quran_tracing/models/order_detail_model.dart';
import 'package:quran_tracing/widgets/order_owner_data.dart';
import 'package:quran_tracing/widgets/order_products.dart';
import 'package:quran_tracing/widgets/received_person_data.dart';
import 'package:http/http.dart' as http;

class OrderItemDetail extends StatefulWidget {
  const OrderItemDetail({required this.id, required this.title, Key? key})
      : super(key: key);

  final String title;
  final String id;

  @override
  State<StatefulWidget> createState() {
    return _OrderItemDetailState();
  }
}

class _OrderItemDetailState extends State<OrderItemDetail> {
  late Future<OrderDetailModel> _futureOrder;
  @override
  void initState() {
    _futureOrder = fetchOrders(widget.id);
    super.initState();
  }

  Future<OrderDetailModel> fetchOrders(String orderId) async {
    var url = Uri.http("quronhusnixati.uz:4000", "/order/$orderId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return OrderDetailModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw (Exception('False'));
    }
  }

  Future<void> patchOrderStatus(String orderId, String status) async {
    var url = Uri.http("quronhusnixati.uz:4000", "/order/status/$orderId");
    try {
      final response = await http.patch(
        url,
        body: {
          'status': status == 'paid'
              ? 'sent'
              : status == 'received'
                  ? 'paid'
                  : 'received',
        },
      );

      if (response.statusCode == 200) {
        // If the patch request is successful (status code 200),
        // you can handle the success here
        print('Order status updated successfully');
      } else {
        // If the server returns an error status code,
        // throw an exception with an appropriate message
        throw Exception(
            'Failed to update order status: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, catch it here
      // and throw an exception with the error message
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderDetailModel>(
      future: _futureOrder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.grey, // Placeholder color
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError && snapshot.error != null) {
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
          final order = snapshot.data;
          Color appBarColor;
          String status;
          if (order != null && order.status == 'received') {
            appBarColor = Color.fromARGB(131, 255, 153, 0);
            status = 'Kelib tushgan';
          } else if (order != null && order.status == 'paid') {
            appBarColor = Color.fromARGB(158, 33, 149, 243);
            status = "To'langan";
          } else {
            appBarColor = Color.fromARGB(151, 76, 175, 79);
            status = "Jo'natilgan";
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: appBarColor,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OrderOwnerData(
                      name:
                          "${order?.user?.tgFirstName ?? 'no firstname'} ${order?.user?.tgLastName ?? 'no lastname'}",
                      username: order?.user?.username ?? 'no username',
                      comment: order?.comment ?? 'no comment',
                    ),
                    OrderProducts(
                      products: order!.products,
                      totalPrice: order.totalPrice!,
                    ),
                    ReceivedPersonData(shippingInfo: order.shippingInfo!),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To'lovni tasdiqlash: ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(appBarColor),
                            ),
                            onPressed: () async {
                              await patchOrderStatus(order.id!, order.status!);

                              // Reload the order details after updating the status
                              setState(() {
                                _futureOrder = fetchOrders(widget.id);
                              });
                            },
                            child: Text(
                              status,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
