import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavourite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  // Product.fromJsonMap(Map<String, dynamic> jsonMap) : id = jsonMap['id'], title = jsonMap['title'],

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;

    final url = Uri.parse(
        'https://flutter-update-8bcdd-default-rtdb.firebaseio.com/products/$id.jsonxx');
    final response = await http.patch(
      url,
      body: json.encode(Product(
        id: id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        isFavourite: isFavourite,
      ).toMap()),
    );

    if (response.statusCode != 200) {
      isFavourite = oldStatus;
      notifyListeners();

      print("could not toggle favourite status, non-200 response");

      throw HttpException('Could not update favourite status.');
    }

    print("isFavourite changed to " +
        isFavourite.toString() +
        " now notifying listeners");
    notifyListeners();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavourite': isFavourite,
      };
}
