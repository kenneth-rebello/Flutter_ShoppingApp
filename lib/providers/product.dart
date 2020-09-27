import 'package:flutter/foundation.dart';
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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
