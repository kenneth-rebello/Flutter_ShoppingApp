import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cartData.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cartData.items.values.toList(),
                          cartData.totalAmount,
                        );
                        cartData.clear();
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartData.itemCount,
                itemBuilder: (ctx, idx) => CartItem(
                  id: cartData.items.values.toList()[idx].id,
                  price: cartData.items.values.toList()[idx].price,
                  quantity: cartData.items.values.toList()[idx].quantity,
                  title: cartData.items.values.toList()[idx].title,
                  productId: cartData.items.keys.toList()[idx],
                ),
              ),
            ),
          ],
        ));
  }
}
