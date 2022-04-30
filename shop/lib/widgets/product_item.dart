import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_detail_screen_args.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // goes up try to find closest Product provided, which is one level up in the GridView.builer()
    final product = context.watch<Product>();
    final cart = context.read<Cart>();

    // Consumer<Product>(child: (context, value, child){}) could be used as well
    // benefit could be only making one part re-render if the data changes
    // for here, we'd wrap the IconButton() so it's interested in changes and
    // the other part of the widget that just cares about thing that don't change
    // (i.e., title, description, price, ...) could just be a read instead of a
    // watch, or a listen:false with the Provider.of<Product>(context, listen: false)

    // the child argument you get in `child: (context, value, child){}` is tied
    // to a child property you can set on the Consumer<Product> constructor and
    // that widget never changes so it could be something that doesn't change
    // just because the consumer does rebuild and then you'd save on rebuilding
    // that piece. if you don't use `child` you can pass `_`

    // could also get away with not using Consumer<> if you split up your widgets

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: ProductDetailScreenArgs(productId: product.id),
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              try {
                await product.toggleFavouriteStatus();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Changing the "${product.title}" favourite status failed'),
                  ),
                );
              }
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added ${product.title} to cart."),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
