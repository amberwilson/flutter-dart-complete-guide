import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    */
  ];
  // var _showFavouritesOnly = false;

  // return a copy so that we know to notify listeners!
  List<Product> get items {
    print("getting all items");
    return [..._items];
  }

  List<Product> get favouriteItems {
    print("getting favourite items");
    return [..._items].where((item) => item.isFavourite).toList();
  }

  // List<Product> get filteredItems {
  //   if (_showFavouritesOnly) {
  //     return _items.where((item) => item.isFavourite).toList();
  //   }

  //   return [..._items];
  // }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;

  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;

  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    print("about to POST body = " + json.encode(product.toMap()));
    final url = Uri.parse(
        'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(product.toMap()),
      );

      print("body" + response.body);
      final postResponse = ProductsPostResponse.fromJson(response.body);

      final newProduct = Product(
        id: postResponse.name,
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);

      throw error;
    }
  }

/*
  Future<void> addProduct(Product product) {
    print("about to POST body = " + json.encode(product.toMap()));
    final url = Uri.parse(
        'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/products.json');

    return http
        .post(
      url,
      body: json.encode(product.toMap()),
    )
        .then((response) {
      print("body" + response.body);
      final postResponse = ProductsPostResponse.fromJson(response.body);

      final newProduct = Product(
        id: postResponse.name,
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);

      notifyListeners();
    }).catchError((error) {
      print("caught error");
      print(error);

      throw error;
    });
  }
  */

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index > -1) {
      final url = Uri.parse(
          'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/products/${product.id}.json');
      http.patch(
        url,
        body: json.encode(product.toMap()),
      );

      _items[index] = product;

      notifyListeners();
    } else {
      print("can't find product with id " + product.id.toString());
    }
  }

  Future<void> deleteProduct(String productId) async {
    final int index = _items.indexWhere((item) => item.id == productId);
    if (index > -1) {
      // keeps a reference in memory so removeAt() doesn't totally lose the product
      var existingProduct = _items[index];

      _items.removeAt(index);
      notifyListeners();

      final url = Uri.parse(
          'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/products/$productId.json');

      try {
        final response = await http.delete(url);
        if (response.statusCode != 200) {
          print("whoa cannot delete");
          throw HttpException('Could not delete product.');
        }
      } catch (error) {
        print("in delete catchError, re-insert product");
        // optimistic updating, re-add if we fail
        _items.insert(index, existingProduct);

        notifyListeners();

        rethrow;
      }

      notifyListeners();
    } else {
      print("can't find product with id " + productId);
    }
  }

  Product findById(String productId) {
    return _items.firstWhere((item) => item.id == productId);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      _items = ProductsGetResponse.fromJson(response.body).products;
      print("done setting _items to Get payload");

      notifyListeners();
    } catch (error) {
      rethrow;
    }
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

class ProductsGetResponse {
  List<Product> products = [];

  ProductsGetResponse.fromJson(String jsonData) {
    final data = json.decode(jsonData);
    data.forEach((productId, productData) {
      products.add(Product(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavourite: productData['isFavourite'],
      ));
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
