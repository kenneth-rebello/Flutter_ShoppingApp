import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;

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
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url =
        'https://native-shopapp-f4694.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);
    final extracted = json.decode(response.body) as Map<String, dynamic>;
    if (extracted == null) {
      return;
    }
    List<OrderItem> loadedOrders = [];
    extracted.forEach((orderId, order) {
      loadedOrders.add(OrderItem(
        amount: order['amount'],
        id: orderId,
        dateTime: DateTime.parse(order['dateTime']),
        products: (order['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cart, double total) async {
    final url =
        'https://native-shopapp-f4694.firebaseio.com/orders/$userId.json?auth=$token';
    final now = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': now.toIso8601String(),
        'products': cart
            .map(
              (c) => {
                'id': c.id,
                'title': c.title,
                'price': c.price,
                'quantity': c.quantity,
              },
            )
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        id: json.decode(response.body)['name'],
        dateTime: now,
        products: cart,
      ),
    );
    notifyListeners();
  }
}
