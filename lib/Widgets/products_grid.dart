import 'package:eshop/Provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;

  const ProductsGrid(this.showFav, {super.key});

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ProductsProvider>(context);
    final products = showFav ? providerData.showFavourite : providerData.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
