import 'package:eshop/Provider/products_provider.dart';
import 'package:eshop/Screens/product_screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;

  const UserProductItem(this.id, this.title, this.imageURL, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              color: Theme
                  .of(context)
                  .primaryColor,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                      const SnackBar(content: Text('Deleting Failed!')));
                }
              },
              icon: const Icon(Icons.delete),
              // color: Theme
              //     .of(context)
              //     .errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
