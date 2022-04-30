import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavourites;

  const ProductsGrid({Key? key, required this.showOnlyFavourites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var products = showOnlyFavourites
        ? context.watch<Products>().favouriteItems
        : context.watch<Products>().items;

    // old way:
    // var products = Provider.of<Products>(context).items;

    return products.isEmpty
        ? const Text('Oops, no products...')
        : GridView.builder(
            padding: const EdgeInsets.all(
              10.0,
            ),
            itemCount: products.length,

            // NOTE ChangeNotifierProvider handles cleaning up data if we load another screen
            // but need to handle that yourself if not using something like that
            // or else get memory leaks
            itemBuilder: (ctx, i) => ChangeNotifierProvider<Product>.value(
              //
              // create: (_) { // _ for arg variable bececause not using BuildContext arg
              //   return products[i];
              // },

              // ok to use value contstructor here because the object (product) already exists
              // https://flutterbyexample.com/lesson/using-value-constructors
              value: products[i],
              child: const ProductItem(
                  // product: products[i],
                  ),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns we want
              childAspectRatio: 3 / 2, // higher than wide
              crossAxisSpacing: 10, // space between columsn
              mainAxisSpacing: 10, // space between rows
            ),
          );
  }
}
