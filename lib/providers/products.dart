import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {

  final String authToken;
  final String userId;
  List<Product> _items = [];

  Products(this.authToken, this.userId, this._items);


  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    String url;
    if (filterByUser)
      url = 'https://shopping-app-3e0d8.firebaseio.com/products.json?auth=$authToken&orderBy="createrId"&equalTo="$userId"';
    else
      url = 'https://shopping-app-3e0d8.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      final favoritesResponse = await http.get('https://shopping-app-3e0d8.firebaseio.com/favorites/$userId.json?auth=$authToken');
      final favoritesData = json.decode(favoritesResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodID, prodData) {
        loadedProducts.add(Product(
          id: prodID,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favoritesData == null ? false: favoritesData[prodID] ?? false,
        ));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      print("ERROR CAUGHT!");
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final url = 'https://shopping-app-3e0d8.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
        'isFavorite': newProduct.isFavorite,
        'createrId' : userId,
      }));
      newProduct = Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
      price: newProduct.price,
      isFavorite: newProduct.isFavorite
      );
      _items.add(newProduct);
      notifyListeners(); 
    } catch (error) {
      print("AMLAN");
      print(error);
      print("AMLAN");
      throw error;
    }     
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final url = 'https://shopping-app-3e0d8.firebaseio.com/products/$id.json?auth=$authToken';
      //Should implement exception handling
      await http.patch(url, body: json.encode({
        'title' : product.title,
        'description' : product.description,
        'imageUrl' : product.imageUrl,
        'price' : product.price
      }));
      _items[index] = product;
      notifyListeners();
    } else {
      print("FAILURE!");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shopping-app-3e0d8.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Couldn't delete product!");
    }
    existingProduct = null;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

}