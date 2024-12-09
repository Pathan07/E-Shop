import 'package:eshop/Provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';

  const ProductsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProducts = Provider.of<ProductsProvider>(context, listen: false)
        .findByID(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProducts.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProducts.title,
              ),
              background: Hero(
                tag: loadedProducts.id,
                child: Image.network(
                  loadedProducts.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  "\$${loadedProducts.price}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProducts.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 800)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
