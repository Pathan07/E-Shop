import 'package:eshop/Provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class cartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productID;

  const cartItem(this.id, this.title, this.price, this.quantity,this.productID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        // color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (context)=> AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you want to remove the item from the cart?"),
          actions: <Widget> [
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: const Text("No")),
            TextButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: const Text("Yes"))
          ],
        ));
      },
      onDismissed: (direction){
       Provider.of<Cart>(context,listen: false).removeItem(productID);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text("\$$price"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Row(
              children: <Widget> [
                Text(DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now())),
                Text("  \$${(price * quantity)}"),
              ],
            ),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
