import 'package:eshop/Provider/cart.dart';
import 'package:eshop/Provider/products_provider.dart';
import 'package:eshop/Screens/cart_screen.dart';
import 'package:eshop/Widgets/app_drawer.dart';
import 'package:eshop/Widgets/badge.dart';
import 'package:eshop/Widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  favourite,
  showAll,
}

class ProductsOverViewScreen extends StatefulWidget {
  static const routeName = '/overview-screen';

  const ProductsOverViewScreen({super.key});

  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool showOnlyFavourite = false;
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favourite) {
                  showOnlyFavourite = true;
                } else {
                  showOnlyFavourite = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favourite,
                child: Text("Only Favourites"),
              ),
              const PopupMenuItem(
                value: FilterOptions.showAll,
                child: Text("Show All"),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => badge(
              value: cart.itemCount.toString(),
              child: ch as Widget,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyFavourite),
      drawer: const AppDrawer(),
    );
  }
}
