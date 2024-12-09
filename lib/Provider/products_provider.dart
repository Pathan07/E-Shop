import 'dart:convert';
import 'package:eshop/Models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> items = [];
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this.items);

  Product findByID(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  List<Product> get item {
    return [...items];
  }

  List<Product> get showFavourite {
    return items.where((productItem) => productItem.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'paste your real-time dataBase URL here (Real-Time firebase URL)//products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      url =
          'paste your real-time dataBase URL here (Real-Time firebase URL)//userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(Uri.parse(url));
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            price: (value['price'] is int)
                ? value['price'].toDouble()
                : value['price'],
            description: value['description'],
            imageURL: value['imageURL'],
            isFavourite:
                favouriteData == null ? false : favouriteData[key] ?? false,
          ),
        );
      });
      items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print("The error in fetching products is: $error");
      rethrow;
    }
  }

  Future<void> addProducts(Product prod) async {
    final url =
        'paste your real-time dataBase URL here (Real-Time firebase URL)//products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': prod.title,
          'price': prod.price,
          'description': prod.description,
          'imageURL': prod.imageURL,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageURL: prod.imageURL);
      items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      try {
        final url =
            'paste your real-time dataBase URL here (Real-Time firebase URL)//products/$id.json?auth=$authToken';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'price': newProduct.price,
              'description': newProduct.description,
              'imageURL': newProduct.imageURL,
            }));
        items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'paste your real-time dataBase URL here (Real-Time firebase URL)//products/$id.json?auth=$authToken';
    final existingProductIndex =
        items.indexWhere((element) => element.id == id);
    var existingProduct = items[existingProductIndex];
    try {
      items.removeAt(existingProductIndex);
      notifyListeners();
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpExcepption("Something went wrong.");
      }
    } catch (error) {
      items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      rethrow;
    }
  }
}
