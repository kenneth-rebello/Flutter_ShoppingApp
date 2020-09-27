import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/product.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product_details';
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final product = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ))
          ],
        ),
      ),
    );
  }
}