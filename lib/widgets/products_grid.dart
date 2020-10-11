import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showOnlyFavorites;

  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        _showOnlyFavorites ? productsData.favoriteItems : productsData.items;

    return RefreshIndicator(
      onRefresh: () => productsData.fetchProducts(),
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
          value: products[idx],
          child: ProductItem(),
        ),
      ),
    );
  }
}
