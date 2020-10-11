import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/edit_product.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Product.fromTemp(TempProduct newProd)
      : id = newProd.id,
        title = newProd.title,
        price = newProd.price,
        description = newProd.description,
        imageUrl = newProd.imageUrl,
        isFavorite = false;

  void toggleFavorite(String token, String userId) async {
    final old = isFavorite;
    isFavorite = !isFavorite;
    final url =
        'https://native-shopapp-f4694.firebaseio.com/favorites/$userId/$id.json?auth=$token';
    notifyListeners();
    try {
      http.put(
        url,
        body: json.encode(isFavorite),
      );
    } catch (e) {
      isFavorite = old;
    }
  }
}
