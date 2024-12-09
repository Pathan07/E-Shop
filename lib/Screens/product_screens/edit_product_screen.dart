import 'package:eshop/Provider/products_provider.dart';
import 'package:eshop/Provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final titleFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageFocusNode = FocusNode();
  final imageUrlControler = TextEditingController();
  final form = GlobalKey<FormState>();
  var editProduct = Product(
    id: "",
    title: "",
    description: "",
    price: 0,
    imageURL: "",
  );
  var initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageURL': '',
  };
  var isInit = true;
  var isLoading = false;

  @override
  void dispose() {
    priceFocusNode.dispose();
    titleFocusNode.dispose();
    imageFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlControler.dispose();
    imageFocusNode.removeListener(updateImageURL);
    super.dispose();
  }

  @override
  void initState() {
    imageFocusNode.addListener(updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productID = ModalRoute.of(context)?.settings.arguments as String;
      if (productID.isNotEmpty) {
        editProduct =
            Provider.of<ProductsProvider>(context).findByID(productID);
        initValues = {
          'title': editProduct.title,
          'price': editProduct.price.toString(),
          'description': editProduct.description,
          'imageURL': '',
        };
        imageUrlControler.text = editProduct.imageURL;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void updateImageURL() {
    if (!imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> saveProduct() async {
    final valid = form.currentState!.validate();
    if (!valid) {
      return;
    }
    final imageURL = imageUrlControler.text;
    if (!isValidImageURL(imageURL)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Image URL'),
          content: const Text('The provided image URL is not valid.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    form.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (editProduct.id.isNotEmpty) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(editProduct.id, editProduct);
      } catch (error) {
        await showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occurred'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(editProduct);
      } catch (error) {
        await showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occurred'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    }
  }

  bool isValidImageURL(String url) {
    final allowedProtocols = [
      'https://',
      'http://',
      'ftp://',
      'file://',
      'data:'
    ];
    return allowedProtocols.any((protocol) => url.startsWith(protocol));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveProduct,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initValues['title'],
                      decoration: const InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a title.";
                        }
                        if (double.tryParse(value) != null) {
                          return 'Enter a text, not a number.';
                        }
                        return null;
                      },
                      focusNode: titleFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(priceFocusNode);
                      },
                      onSaved: (value) {
                        editProduct = Product(
                          id: editProduct.id,
                          isFavourite: editProduct.isFavourite,
                          title: value.toString(),
                          description: editProduct.description,
                          price: editProduct.price,
                          imageURL: editProduct.imageURL,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['price'],
                      decoration: const InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a price.";
                        }
                        double? parsedValue = double.tryParse(value);
                        if (parsedValue == null) {
                          return 'Enter a valid number.';
                        }
                        if (parsedValue <= 0) {
                          return 'Enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editProduct = Product(
                            id: editProduct.id,
                            isFavourite: editProduct.isFavourite,
                            title: editProduct.title,
                            description: editProduct.description,
                            price: double.parse(value!),
                            imageURL: editProduct.imageURL);
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['description'],
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a description";
                        }
                        if (value.length <= 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editProduct = Product(
                            id: editProduct.id,
                            isFavourite: editProduct.isFavourite,
                            title: editProduct.title,
                            description: value.toString(),
                            price: editProduct.price,
                            imageURL: editProduct.imageURL);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: imageUrlControler.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    imageUrlControler.text,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: imageUrlControler,
                            focusNode: imageFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter an image URL';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              saveProduct();
                            },
                            onSaved: (value) {
                              editProduct = Product(
                                id: editProduct.id,
                                isFavourite: editProduct.isFavourite,
                                title: editProduct.title,
                                description: editProduct.description,
                                price: editProduct.price,
                                imageURL: value.toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
