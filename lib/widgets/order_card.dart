import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrderCard extends StatefulWidget {

  final Order currentOrder;

  OrderCard(this.currentOrder);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(
              "\$ " + widget.currentOrder.amount.toStringAsFixed(2),
              style: Theme.of(context).textTheme.title,
            ),
            leading: Text(
              DateFormat('dd/MM/yyyy').format(widget.currentOrder.dateTime),
              style: TextStyle(
                fontFamily: "Anton",
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
        ),
        if (_expanded) Container(
          height: min(widget.currentOrder.products.length * 50.0, 180),
          child: ListView.builder(
            itemCount: widget.currentOrder.products.length,
            itemBuilder: (ctx, index) => OrderItem(
              widget.currentOrder.products[index].title,
              widget.currentOrder.products[index].price.toString() + " x " + widget.currentOrder.products[index].quantity.toString(),
            ),
          ),
        ),
      ],
    );
  }
}