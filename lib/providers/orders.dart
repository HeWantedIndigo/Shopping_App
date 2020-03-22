import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cart.dart';

class Order {

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    @required this.id, 
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });

}

class Orders with ChangeNotifier {

  final String authToken;
  final String userId;
  List<Order> _orders = [];

  Orders(this.authToken, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shopping-app-3e0d8.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      final List<Order> loadedOrders = [];
      if (extractedData != null) {
        extractedData.forEach((orderID, orderData) {
          loadedOrders.add(Order(
            id: orderID,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title'],
              )
            ).toList(),
          ));
          _orders = loadedOrders;
        });
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }


  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = 'https://shopping-app-3e0d8.firebaseio.com/orders/$userId.json?auth=$authToken';
    //Can attempt try catch
    final response = await http.post(url, body: json.encode({
      'amount' : total,
      'dateTime' : timeStamp.toIso8601String(),
      'products' : cartProducts.map(
        (cartItem) => {
          'id' : cartItem.id,
          'title' : cartItem.title,
          'quantity' : cartItem.quantity,
          'price' : cartItem.price,
        } 
      ).toList(),
    }));
    _orders.insert(0, Order(id: json.decode(response.body)['name'], amount: total, products: cartProducts, dateTime: timeStamp));
    notifyListeners();
  }

}