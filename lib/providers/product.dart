import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id, 
    @required this.title, 
    @required this.description, 
    @required this.imageUrl, 
    @required this.price, 
    this.isFavorite = false,
    });

    Future<void> toggleFavorite(String authToken, String userId) async {
      final url = 'https://shopping-app-3e0d8.firebaseio.com/favorites/$userId/$id.json?auth=$authToken';
      final oldStatus = isFavorite;
      isFavorite = !isFavorite;
      notifyListeners();
      try {
        final response = await http.put(url, body: json.encode(isFavorite,
      ));
        if (response.statusCode >= 400) {
          isFavorite = oldStatus;
          notifyListeners();
        }
      } catch (error) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    }
}