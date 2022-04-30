class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  CartItem.fromJsonMap(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        title = jsonMap['title'],
        price = jsonMap['price'],
        quantity = jsonMap['quantity'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'quantity': quantity,
        'price': price,
      };
}
