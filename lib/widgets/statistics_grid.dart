import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_tracing/widgets/statistics_grid_items.dart';

class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid(
      {super.key,
      required this.totalOrders,
      required this.totalUsers,
      required this.totalProducts,
      required this.totalSoldProducts});
  final String totalUsers;
  final String totalProducts;
  final String totalOrders;
  final String totalSoldProducts;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          StatisticsGridItem(
            number: totalUsers,
            type: "Foydalanuvchilar",
            icon: Icons.people_outline_rounded,
          ),
          StatisticsGridItem(
            number: totalProducts,
            type: "Maxsulotlar",
            icon: Icons.storefront_outlined,
          ),
          StatisticsGridItem(
            number: totalOrders,
            type: "Buyurtmalar",
            icon: Icons.shopping_cart_outlined,
          ),
          StatisticsGridItem(
            number: totalSoldProducts,
            type: "Sotilgan Maxsulotlar",
            icon: Icons.shopping_bag_outlined,
          ),
        ],
      ),
    );
  }
}
