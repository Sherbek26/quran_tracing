import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_tracing/models/statistics_model.dart';
import 'package:quran_tracing/widgets/statistics_grid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class _StatisticScreenState extends State<StatisticScreen> {
  late Future<Root> futureStatistics;

  @override
  void initState() {
    futureStatistics = fetchStatistics();
    super.initState();
  }

  Future<Root> fetchStatistics() async {
    String? token = await getToken();
    var url = Uri.http("quronhusnixati.uz:4000", "/statistics/all");
    final response = await http.get(url, headers: {"Authorization": token!});
    if (response.statusCode == 200) {
      return Root.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  Future<void> _refreshStatistics() async {
    setState(() {
      futureStatistics = fetchStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoScrollbar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: _refreshStatistics,
            child: FutureBuilder<Root>(
              future: futureStatistics,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading data: ${snapshot.error}'),
                  );
                } else {
                  final statistics = snapshot.data;
                  return Column(
                    children: [
                      Text(
                        'Umumiy savdo:',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${statistics!.totalSales} so`m',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: CupertinoColors.systemYellow)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      StatisticsGrid(
                        totalOrders: statistics.totalOrders.toString(),
                        totalUsers: statistics.totalUsers.toString(),
                        totalProducts: statistics.totalProducts.toString(),
                        totalSoldProducts:
                            statistics.totalSoldProducts.toString(),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
