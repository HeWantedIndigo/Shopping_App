import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/waiting_screen.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(auth.token, auth.userId, previousProducts.items == null ? [] : previousProducts.items),
          create: (_) => Products(null, null, []),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId, previousOrders.orders == null ? [] : previousOrders.orders),
          create: (_) => Orders(null, null, []),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: "Flipkart",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.amber,
            textTheme: TextTheme(
              body1: TextStyle(
                color: Colors.black,
                fontFamily: "Heebo",
                fontSize: 20,
              ),
              body2: TextStyle(
                color: Colors.white,
                fontFamily: "Heebo",
                fontSize: 12,
              ),
              title: TextStyle(
                color: Colors.amber,
                fontSize: 36,
                fontFamily: "Anton",
              ),
            ),
          ),
          home: auth.isAuth ? ProductOverviewScreen() : FutureBuilder(
            future: auth.tryAutoLogIn(),
            builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ?
              WaitingScreen() : AuthScreen(),
          ),
          routes: {
            ProductDetailsScreen.routeName : (ctx) => ProductDetailsScreen(),
            CartScreen.routeName : (ctx) => CartScreen(),
            OrdersScreen.routeName : (ctx) => OrdersScreen(),
            UserProductsScreen.routeName : (ctx) => UserProductsScreen(),
            EditProductScreen.routeName : (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}