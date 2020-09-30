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
                    OrderButton(cartData: cartData)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : FlatButton(
            onPressed: (widget.cartData.totalAmount <= 0) || _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cartData.items.values.toList(),
                      widget.cartData.totalAmount,
                    );
                    widget.cartData.clear();
                    setState(() {
                      _isLoading = false;
                    });
                  },
            child: Text(
              'ORDER NOW',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
          );
  }
}
