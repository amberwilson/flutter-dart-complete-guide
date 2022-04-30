import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

import 'cart_item.dart';
import 'order_item.dart';

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> products, double total) async {
    final orderItem = OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      products: products,
      dateTime: DateTime.now(),
    );
    final orderTime = DateTime.now();

    print("save order");
    print(json.encode(orderItem.toMap()));

    final url = Uri.parse(
        'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(orderItem.toMap()),
      );

      print("body" + response.body);
      final postResponse = OrdersPostResponse.fromJson(response.body);

      final newOrderItem = OrderItem(
        id: postResponse.name,
        amount: total,
        products: products,
        dateTime: orderTime,
      );

      _orders.insert(0, newOrderItem);

      notifyListeners();
    } catch (error) {
      print(error);
      _orders.removeAt(0);

      notifyListeners();

      rethrow;
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.get(url);
      print(response.body);
      // _items = OrdersGetResponse.fromJson(response.body).products;
      // print("done setting _items to orders Get payload");

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

class OrdersPostResponse {
  late String name;

  OrdersPostResponse(this.name);

  OrdersPostResponse.fromJson(String jsonData) {
    final data = json.decode(jsonData);
    name = data['name'];
  }
}

class ProductsPostResponse {
  late String name;

  ProductsPostResponse(this.name);

  ProductsPostResponse.fromJson(String jsonData) {
    final data = json.decode(jsonData);
    name = data['name'];
  }
}

class OrdersGetResponse {
  final List<OrderItem> _orders = [];

  OrdersGetResponse.fromJson(String jsonData) {
    final data = json.decode(jsonData);
    data.forEach((orderId, orderData) {
      _orders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<Product>)
              .map((productData) => CartItem.fromJsonMap(productData))
              .toList()));
    });
  }

  Map<String, Map<String, dynamic>> toMap() {
    final Map<String, Map<String, dynamic>> map = {};

    for (final product in products) {
      map[product.id] = product.toMap();
    }

    return map;

    // {
    //   'id': id,
    //   'title': title,
    //   'description': description,
    //   'price': price,
    //   'imageUrl': imageUrl,
    // };
  }
}
