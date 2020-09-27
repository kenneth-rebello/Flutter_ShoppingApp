import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';

import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details.dart';
import './screens/products_overview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Shop App Title',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverview(),
        routes: {
          ProductDetails.routeName: (ctx) => ProductDetails(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
