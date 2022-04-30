import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import 'edit_product_screen_args.dart';
import 'product_detail_screen.dart';
import 'product_detail_screen_args.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

Widget _appBarTitle(Product product) {
  if (product.id == "") {
    return const Text("Add Product");
  } else {
    return Text("Edit Product: ${product.title}");
  }
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _product = Product(
    id: '',
    title: 'Test 1',
    price: 12,
    description: 'A description for the test item.',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg',
  );
  bool _isNew = true;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _imageUrlController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;

      var args = ModalRoute.of(context)!.settings.arguments;
      if (args is EditProductScreenArgs) {
        _isNew = false;
        _product = args.product;
      }

      _imageUrlController.text = _product.imageUrl;
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    if (!(_form.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState?.save();

    // if it's a new product, set the id
    if (_isNew) {
      print("in new block");
      try {
        await context.read<Products>().addProduct(_product);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${_product.title}" added'),
          ),
        );
      } catch (error) {
        print("caught error in edit_product_screen");
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    } else {
      print("in edit block");
      await context.read<Products>().updateProduct(_product);
      print("done updateProduct");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${_product.title}" product updated'),
          action: SnackBarAction(
            label: 'VIEW',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                  ProductDetailScreen.routeName,
                  arguments: ProductDetailScreenArgs(productId: _product.id));
            },
          ),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print("build edit product screen");
    print(_isLoading.toString());
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(_product),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _product.title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _product = Product(
                          id: _product.id,
                          title: value ?? '',
                          price: _product.price,
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          isFavourite: _product.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _product.price.toStringAsFixed(2),
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _product = Product(
                          id: _product.id,
                          title: _product.title,
                          price: double.parse(value ?? ''),
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          isFavourite: _product.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }

                        final price = double.tryParse(value);

                        if (price == null) {
                          return 'Must be a price in dollars and cents';
                        }

                        if (price <= 0) {
                          return 'Must be greater than 0.00';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _product.description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _product = Product(
                          id: _product.id,
                          title: _product.title,
                          price: _product.price,
                          description: value ?? '',
                          imageUrl: _product.imageUrl,
                          isFavourite: _product.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }

                        if (value.length < 10) {
                          return 'Must be at least 10 characters';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                        ),
                        Expanded(
                          child: Focus(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                setState(() {});
                                _saveForm();
                              },
                              onSaved: (value) {
                                _product = Product(
                                  id: _product.id,
                                  title: _product.title,
                                  price: _product.price,
                                  description: _product.description,
                                  imageUrl: value ?? '',
                                  isFavourite: _product.isFavourite,
                                );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }

                                final url = Uri.tryParse(value);

                                if (url != null) {
                                  if (!url.isAbsolute) {
                                    return 'Must be a valid URL';
                                  }
                                }

                                return null;
                              },
                            ),
                            onFocusChange: (bool hasFocus) {
                              final value = _imageUrlController.text;
                              if (value.isNotEmpty) {
                                final url = Uri.tryParse(value);

                                if (url != null) {
                                  if (!url.isAbsolute) {
                                    return;
                                  }
                                }
                              }

                              if (!hasFocus) {
                                // bump state to get the build() to run
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
