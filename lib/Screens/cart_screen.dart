import 'package:eshop/Provider/cart.dart' show Cart;
import 'package:eshop/Provider/Orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/cart_things.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => cartItem(
                cart.item[index].id,
                cart.item[index].title,
                cart.item[index].price,
                cart.item[index].quantity,
                cart.item[index].id,
              ),
              itemCount: cart.item.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.totalPrice <= 0
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false)
                    .addOrder(widget.cart.items, widget.cart.totalPrice);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deleting Failed!')));
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
              widget.cart.clear();
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text("ORDER NOW"),
    );
  }
}
