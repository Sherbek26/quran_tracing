import 'package:flutter/material.dart';
import 'package:quran_tracing/widgets/order_list.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool transitioning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this, animationDuration: Duration(seconds: 1))
      ..addListener(_handleTabIndexChanged);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Barchasi"),
            Tab(text: "Kelib tushgan"),
            Tab(text: "Jo'natilgan"),
            Tab(text: "To'langan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrdersList(title: ''),
          OrdersList(title: 'received'),
          OrdersList(title: 'sent'),
          OrdersList(title: 'paid')
        ],
      ),
    );
  }
}
