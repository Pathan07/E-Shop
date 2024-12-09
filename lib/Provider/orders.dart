import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> product;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.product,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this.orders);

  List<OrderItem> get order {
    return [...orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'paste your real-time dataBase URL here (Real-Time firebase URL)//orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderID, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderID,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          product: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ),
      );
    });
    orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final url =
          'paste your real-time dataBase URL here (Real-Time firebase URL)//orders/$userId.json?auth=$authToken';
      final timeStamp = DateTime.now();
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList()
          }));
      orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          product: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw Exception('An error occurred while adding the order: $error');
    }
  }
}
