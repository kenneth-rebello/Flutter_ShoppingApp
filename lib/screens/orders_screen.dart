import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context, listen: false).fetchOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => orderData.fetchOrders(),
        child: ListView.builder(
          itemBuilder: (ctx, idx) => OrderItem(orderData.orders[idx]),
          itemCount: orderData.orders.length,
        ),
      ),
    );
  }
}
