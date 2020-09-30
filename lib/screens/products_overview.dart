import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import '../widgets/main_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum Options {
  Favorites,
  All,
}

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;
  var isLoading = false;

  @override
  void initState() {
    isLoading = true;
    Provider.of<Products>(context, listen: false).fetchProducts().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (Options value) {
              setState(() {
                if (value == Options.Favorites) {
                  // productsData.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  // productsData.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: Options.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: Options.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, childBtn) => Badge(
              child: childBtn,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
