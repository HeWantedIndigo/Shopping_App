import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/cart_item_card.dart';

import '../providers/cart.dart';
import '../widgets/cart_summary_card.dart';

class CartScreen extends StatelessWidget {

  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Column(
        children: <Widget>[
          CartSummaryCard(cart.total),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.numberOfItems,
              itemBuilder: (
                (ctx, index) => CartItemCard(cart.items.values.toList()[index], cart.items.keys.toList()[index])
              ),
            ),
          ),
        ],
      ),
    );
  }
}