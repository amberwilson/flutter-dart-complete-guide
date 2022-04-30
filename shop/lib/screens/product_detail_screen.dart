import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_detail_screen_args.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productId =
        (ModalRoute.of(context)!.settings.arguments as ProductDetailScreenArgs)
            .productId;

    var product = context.read<Products>().findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              child: SelectableText(
                product.description + "something that we'd want to have wrap",
                textAlign: TextAlign.center,
                // softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
