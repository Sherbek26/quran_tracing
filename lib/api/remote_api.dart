import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quran_tracing/models/orders_model.dart';

class RemoteAPI {
  Future<OrdersModel> getOrders(int page, int pageSize) async {
    var url = Uri.http("quronhusnixati.uz:4000", "/order/all", {
      "page": "$page",
      "limit": "$pageSize",
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return OrdersModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw (Exception('Fales'));
    }
  }
}
