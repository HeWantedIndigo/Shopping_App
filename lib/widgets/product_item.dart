import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final displayProduct = Provider.of<Product>(context, listen: false);
    final myCart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/product_details_screen', arguments: displayProduct.id);
          },
          child: Image.network(displayProduct.imageUrl, fit: BoxFit.cover)),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, displayProduct, child ) => 
              IconButton(
                icon: displayProduct.isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                onPressed: displayProduct.toggleFavorite,
                iconSize: 15,
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                myCart.addItems(displayProduct.id, displayProduct.price, displayProduct.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.black54,
                    content: Text(
                      "Added to Cart!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        myCart.removeSingleItem(displayProduct.id);
                      },
                    ),
                  )
                );
              },
              iconSize: 15,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              displayProduct.title,
              style: Theme.of(context).textTheme.body2,
              textAlign: TextAlign.center,
            ),
        ),
      ),
    );
  }
}