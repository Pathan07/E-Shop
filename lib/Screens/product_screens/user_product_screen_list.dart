import 'package:eshop/Screens/product_screens/edit_product_screen.dart';
import 'package:eshop/Widgets/app_drawer.dart';
import 'package:eshop/Widgets/user_product_item_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});
  static const routeName = '/user-product';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: '');
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, productData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Column(
                            children: <Widget>[
                              UserProductItem(
                                productData.item[index].id,
                                productData.item[index].title,
                                productData.item[index].imageURL,
                              ),
                              const Divider(),
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
        future: refreshProducts(context),
      ),
    );
  }
}
