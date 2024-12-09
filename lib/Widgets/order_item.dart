import 'dart:math';

import 'package:eshop/Provider/Orders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderThing extends StatefulWidget {
  final OrderItem order;

  const OrderThing(this.order, {super.key});

  @override
  State<OrderThing> createState() => _OrderThingState();
}

class _OrderThingState extends State<OrderThing> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: expanded ? min(widget.order.product.length * 20 + 120, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("\$${widget.order.amount}"),
              subtitle: Text(
                DateFormat("dd/MM/yyyy  hh:mm").format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: expanded
                  ? min(widget.order.product.length * 20 + 20, 100)
                  : 0,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  // final prodImage = Provider.of<ProductsProvider>(context,listen: false);
                  final prod = widget.order.product[index];
                  return ListTile(
                    // leading: CircleAvatar(
                    //   maxRadius: 20,
                    //   // Adjust this value based on your preference
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(2.0),
                    //     child: FittedBox(
                    //       child: Text(
                    //         prod.title.isNotEmpty
                    //             ? prod.title.split(' ')[0]
                    //             : "",
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // backgroundImage: NetworkImage(prodImage.item[index].imageURL),
                    subtitle: Text(
                      DateFormat("dd/MM/yyyy hh:mm")
                          .format(DateTime.now()), // Format DateTime.now()
                    ),
                    title: Text(prod.title,style: const TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Text("${prod.quantity}x  \$${prod.price}"),
                  );
                },
                itemCount: widget.order.product.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
