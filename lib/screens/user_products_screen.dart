import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user_products_screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Products",
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) : RefreshIndicator(
          onRefresh: () => _refreshProducts(ctx),
          child: Consumer<Products>(
            builder: (ctx, productsData, _) => Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    UserProductItem(
                      productsData.items[index].id, 
                      productsData.items[index].title, 
                      productsData.items[index].imageUrl
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}