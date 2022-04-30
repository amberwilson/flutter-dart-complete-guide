import '../providers/product.dart';

class EditProductScreenArgs {
  final Product product;

  EditProductScreenArgs({required this.product});

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
    };
  }
}
