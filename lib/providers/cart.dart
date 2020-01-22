import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }
  void addItems(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(id, (existingItem) => CartItem(
        id: existingItem.id,
        title: existingItem.title,
        quantity: existingItem.quantity + 1,
        price: existingItem.price,
      )
    );
    } else {
      _items.putIfAbsent(id, () => CartItem(
        id: DateTime.now().toString(), 
        title: title, 
        quantity: 1, 
        price: price
        )
      );
    }
    notifyListeners();
  }

  void removeItems(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(id, (existingItem) => CartItem(
        id: existingItem.id,
        title: existingItem.title,
        price: existingItem.price,
        quantity: existingItem.quantity - 1,
        )
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  int get numberOfItems {
    return _items.length;
  }

  double get total {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

}