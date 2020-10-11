import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product.dart';
import '../widgets/main_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';

class UserProducts extends StatefulWidget {
  static const routeName = '/user_products';

  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  Future<void> refresher(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  bool _loading = true;

  @override
  void initState() {
    Provider.of<Products>(context, listen: false).fetchProducts(true).then((_) {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => refresher(context),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemBuilder: (_, idx) => UserProductItem(
                    productData.items[idx].id,
                    productData.items[idx].title,
                    productData.items[idx].imageUrl,
                  ),
                  itemCount: productData.items.length,
                ),
              ),
            ),
    );
  }
}
