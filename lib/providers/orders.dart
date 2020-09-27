import 'package:flutter/material.dart';
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.amount,
    @required this.id,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cart, double total) {
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        id: DateTime.now().toString(),
        dateTime: DateTime.now(),
        products: cart,
      ),
    );
    notifyListeners();
  }
}
