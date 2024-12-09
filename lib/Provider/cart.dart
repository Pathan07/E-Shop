import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  List<CartItem> items = [];

  List<CartItem> get item {
    return [...items];
  }

  int get itemCount {
    return items.length;
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addItem(String productID, String title, double price) {

    final existingItemIndex = items.indexWhere((item) => item.id == productID);
    if (existingItemIndex >= 0) {
      items[existingItemIndex].quantity++;
    } else {
      items.add(
        CartItem(
          id: productID,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    items.removeWhere((item) => item.id == productID);
    notifyListeners();
  }

  void clear() {
    items = [];
    notifyListeners();
  }

  void removeSingleItemFromCart(String productID) {
    final int index = items.indexWhere((item) => item.id == productID);

    if (index == -1) {
      return; // Product not in cart
    }
    if (items[index].quantity > 1) {
      items[index].quantity--;
    } else {
      items.removeAt(index);
    }
    notifyListeners();
  }
}
