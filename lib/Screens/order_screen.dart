import 'package:eshop/Provider/Orders.dart';
import 'package:eshop/Widgets/Order_Item.dart';
import 'package:eshop/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapShot.error != null) {
              return const Center(
                child: Text('No orders yet!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderItem, child) => ListView.builder(
                  itemCount: orderItem.order.length,
                  itemBuilder: (context, index) => OrderThing(
                    orderItem.order[index],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
