import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shop/providers/products.dart';

import '../providers/product.dart';
import '../screens/edit_product_screen.dart';
import '../screens/edit_product_screen_args.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  const UserProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    EditProductScreen.routeName,
                    arguments: EditProductScreenArgs(
                      product: product,
                    ),
                  );
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final productsProvider = context.read<Products>();
                  try {
                    await productsProvider.deleteProduct(product.id);

                    ScaffoldMessenger.of(scaffold.context).showSnackBar(
                      SnackBar(
                        content: Text('"${product.title}" product deleted'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            productsProvider.addProduct(product);
                          },
                        ),
                      ),
                    );
                  } catch (error) {
                    print("in delete catch");
                    ScaffoldMessenger.of(scaffold.context)
                        .removeCurrentSnackBar();
                    ScaffoldMessenger.of(scaffold.context).showSnackBar(
                      SnackBar(
                        content: Text('Deleting "${product.title}" failed'),
                      ),
                    );
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          )),
    );
  }
}
