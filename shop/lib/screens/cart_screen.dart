import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart';
import 'orders_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final cartItems = cart.items.values.toList();

    print("build CartScreen");

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
          actions: [
            IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Empty Cart?'),
                  content: const Text('This will empty your cart. Continue?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        cart.clear();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.delete),
              // child: const Text('Empty Cart'),
            ),
          ],
        ),
        body: Column(
          children: [
            cartItems.isNotEmpty
                ? CartTotal(
                    cart: cart,
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Your cart is currently empty.'),
                  ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item = cartItems[index];

                  return CartItem(
                    id: item.id,
                    productId: cart.items.keys.toList()[index],
                    title: item.title,
                    price: item.price,
                    quantity: item.quantity,
                  );
                },
                itemCount: cart.items.length,
              ),
            ),
          ],
        ));
  }
}

class CartTotal extends StatelessWidget {
  final Cart cart;

  const CartTotal({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 10),
            Chip(
              label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.bodyText1!.color,
                  )),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            OrderNowButton(cart: cart)
          ],
        ),
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await context.read<Orders>().addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalAmount,
                  );

              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
    );
  }
}
