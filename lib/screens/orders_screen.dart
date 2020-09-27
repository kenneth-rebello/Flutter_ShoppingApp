import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
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
      body: ListView.builder(
        itemBuilder: (ctx, idx) => OrderItem(orderData.orders[idx]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
