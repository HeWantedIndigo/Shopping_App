import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartSummaryCard extends StatelessWidget {

  final double total;
  
  CartSummaryCard(this.total);

  @override
  Widget build(BuildContext context) {

    var myCart = Provider.of<Cart>(context);

    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Total",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Chip(
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(
                  "\$ " + total.toStringAsFixed(2),
                  style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FlatButton(
                child: Text(
                  "ORDER NOW",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Provider.of<Orders>(context).addOrder(myCart.items.values.toList(), total);
                  myCart.clearCart();
                  print("test");
                },
              ),
            )
          ],
        )
      ),
    );
  }
}