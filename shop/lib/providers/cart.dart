import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  void justnotify() {
    print("just notify");
    notifyListeners();
  }

  int get itemCount {
    return _items.entries.fold<int>(
        0, (previousValue, item) => previousValue + item.value.quantity);
  }

  double get totalAmount {
    return _items.entries.fold<double>(
        0,
        (previousValue, item) =>
            previousValue + item.value.quantity * item.value.price);
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) {
          final c = CartItem(
            id: DateTime.now().toString(),
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1,
          );
          print("udpating CartItem in cart");
          print(c.toMap());

          return c;
        },
      );

      print("updated item, _items = ");
      // print(json.encode(_items));
    } else {
      final c = CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      );
      print("adding CartItem to cart");
      print(c.toMap());
      _items.putIfAbsent(
        productId,
        () => c,
      );

      print("added new item, _items = ");
      // print(json.encode(_items));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);

    print("remove for productId $productId CartItem, _items = " +
        json.encode(_items));

    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCardItem) => CartItem(
                id: existingCardItem.id,
                title: existingCardItem.title,
                price: existingCardItem.price,
                quantity: existingCardItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();

    notifyListeners();
  }
}
