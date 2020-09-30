import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;
  Future<void> fetchProducts() async {
    const url = 'https://native-shopapp-f4694.firebaseio.com/products.json';
    try {
      final res = await http.get(url);
      final prodData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> products = [];
      if (prodData == null) {
        return;
      }
      prodData.forEach((key, product) {
        products.add(
          Product(
            id: key,
            title: product['title'],
            description: product['description'],
            price: product['price'].toDouble(),
            isFavorite: product['isFavorite'],
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
    const url = 'https://native-shopapp-f4694.firebaseio.com/products.json';
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite
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
    final url = 'https://native-shopapp-f4694.firebaseio.com/products/$id.json';
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
        'https://native-shopapp-f4694.firebaseio.com/products/$prodId.json';
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
