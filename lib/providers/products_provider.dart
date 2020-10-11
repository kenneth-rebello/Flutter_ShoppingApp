import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  // var _showFavoritesOnly = false;
  Future<void> fetchProducts([bool filter = false]) async {
    String filterUrl = filter ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    String url =
        'https://native-shopapp-f4694.firebaseio.com/products.json?auth=$authToken$filterUrl';
    try {
      final res = await http.get(url);
      final prodData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> products = [];
      if (prodData == null) {
        return;
      }
      url =
          'https://native-shopapp-f4694.firebaseio.com/favorites/$userId.json?auth=$authToken';
      final res2 = await http.get(url);
      final favorites = json.decode(res2.body);
      prodData.forEach((prodId, product) {
        products.add(
          Product(
            id: prodId,
            title: product['title'],
            description: product['description'],
            price: product['price'].toDouble(),
            isFavorite: favorites == null
                ? false
                : favorites[prodId] == null ? false : favorites[prodId],
            imageUrl: product['imageUrl'],
          ),
        );
      });
      _items = products;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return [..._items.where((prod) => prod.isFavorite).toList()];
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [..._items.where((prod) => prod.isFavorite).toList()];
  }

  Future<void> addProduct(Product product) {
    final url =
        'https://native-shopapp-f4694.firebaseio.com/products.json?auth=$authToken';
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId,
      }),
    )
        .then(
      (res) {
        _items.add(new Product(
            id: json.decode(res.body)['name'],
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl));
        notifyListeners();
      },
    ).catchError((err) {
      throw err;
    });
  }

  Future<void> updateProduct(String id, Product product) async {
    final ind = _items.indexWhere((prod) => prod.id == id);
    final url =
        'https://native-shopapp-f4694.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    );
    if (ind >= 0) {
      _items[ind] = product;
      notifyListeners();
    } else {}
  }

  void deleteProduct(String prodId) {
    final url =
        'https://native-shopapp-f4694.firebaseio.com/products/$prodId.json?auth=$authToken';
    final index = _items.indexWhere((prod) => prod.id == prodId);
    var existing = _items[index];
    _items.removeAt(index);
    http.delete(url).then((_) {
      existing = null;
    }).catchError((_) {
      _items.insert(index, existing);
    });
    notifyListeners();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
