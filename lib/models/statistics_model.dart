/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class Id {
  int? year;
  int? month;

  Id({this.year, this.month});

  Id.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    return data;
  }
}

class Root {
  int? totalUsers;
  List<TotalUsersCountByMonth?>? totalUsersCountByMonth;
  int? totalProducts;
  int? totalOrders;
  int? totalSales;
  int? totalSoldProducts;
  List<TotalOrderPriceByYearMonth?>? totalOrderPriceByYearMonth;

  Root(
      {this.totalUsers,
      this.totalUsersCountByMonth,
      this.totalProducts,
      this.totalOrders,
      this.totalSales,
      this.totalSoldProducts,
      this.totalOrderPriceByYearMonth});

  Root.fromJson(Map<String, dynamic> json) {
    totalUsers = json['totalUsers'];
    if (json['totalUsersCountByMonth'] != null) {
      totalUsersCountByMonth = <TotalUsersCountByMonth>[];
      json['totalUsersCountByMonth'].forEach((v) {
        totalUsersCountByMonth!.add(TotalUsersCountByMonth.fromJson(v));
      });
    }
    totalProducts = json['totalProducts'];
    totalOrders = json['totalOrders'];
    totalSales = json['totalSales'];
    totalSoldProducts = json['totalSoldProducts'];
    if (json['totalOrderPriceByYearMonth'] != null) {
      totalOrderPriceByYearMonth = <TotalOrderPriceByYearMonth>[];
      json['totalOrderPriceByYearMonth'].forEach((v) {
        totalOrderPriceByYearMonth!.add(TotalOrderPriceByYearMonth.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['totalUsers'] = totalUsers;
    data['totalUsersCountByMonth'] = totalUsersCountByMonth != null
        ? totalUsersCountByMonth!.map((v) => v?.toJson()).toList()
        : null;
    data['totalProducts'] = totalProducts;
    data['totalOrders'] = totalOrders;
    data['totalSales'] = totalSales;
    data['totalSoldProducts'] = totalSoldProducts;
    data['totalOrderPriceByYearMonth'] = totalOrderPriceByYearMonth != null
        ? totalOrderPriceByYearMonth!.map((v) => v?.toJson()).toList()
        : null;
    return data;
  }
}

class TotalOrderPriceByYearMonth {
  Id? id;
  int? totalPrice;

  TotalOrderPriceByYearMonth({this.id, this.totalPrice});

  TotalOrderPriceByYearMonth.fromJson(Map<String, dynamic> json) {
    id = json['_id'] != null ? Id?.fromJson(json['_id']) : null;
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id!.toJson();
    data['totalPrice'] = totalPrice;
    return data;
  }
}

class TotalUsersCountByMonth {
  Id? id;
  int? totalUsers;

  TotalUsersCountByMonth({this.id, this.totalUsers});

  TotalUsersCountByMonth.fromJson(Map<String, dynamic> json) {
    id = json['_id'] != null ? Id?.fromJson(json['_id']) : null;
    totalUsers = json['totalUsers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id!.toJson();
    data['totalUsers'] = totalUsers;
    return data;
  }
}
