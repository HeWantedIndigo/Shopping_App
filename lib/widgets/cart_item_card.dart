import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemCard extends StatelessWidget {

  final CartItem cartItem;
  final String productId;

  CartItemCard(this.cartItem, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(cartItem.id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure ?"),
            content: Text("Do you want to remove this item from Cart?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          )
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItems(productId);
      },
      background: Container(
        margin: EdgeInsets.all(10),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
      ),
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          color: Theme.of(context).primaryColor,
          child: ListTile(
            leading: Chip(
              backgroundColor: Theme.of(context).accentColor,
              label: Text(
                "\$ " + cartItem.price.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(
              cartItem.title,
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Anton",
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            subtitle: Text(
              "Total - \$${cartItem.price * cartItem.quantity}",
              style: TextStyle(
                fontSize: 18,
                //fontFamily: "Anton",
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Text(
                cartItem.quantity.toString() + "x",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}