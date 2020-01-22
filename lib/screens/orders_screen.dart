import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {

  static const routeName = '/orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    var myOrders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : 
      ListView.builder(
        itemCount: myOrders.orders.length,
        itemBuilder: (
          (ctx, index) => OrderCard(myOrders.orders[index])
        ),
      ),
    );
  }
}