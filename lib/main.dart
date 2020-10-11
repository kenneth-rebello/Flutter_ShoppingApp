import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './providers/auth.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';

import './screens/auth_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details.dart';
import './screens/products_overview.dart';
import './screens/user_products.dart';
import './screens/edit_product.dart';

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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProd) => Products(
              auth.token, auth.userId, prevProd == null ? [] : prevProd.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrd) => Orders(
              auth.token, auth.userId, prevOrd == null ? [] : prevOrd.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop App Title',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            errorColor: Colors.red,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverview()
              : FutureBuilder<bool>(
                  future: auth.autoLogIn(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetails.routeName: (ctx) => ProductDetails(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProducts.routeName: (ctx) => UserProducts(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
