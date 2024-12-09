import 'package:eshop/Helpers/custom_route.dart';
import 'package:eshop/Provider/auth.dart';
import 'package:eshop/Provider/Orders.dart';
import 'package:eshop/Provider/products_provider.dart';
import 'package:eshop/Screens/cart_screen.dart';
import 'package:eshop/Screens/product_screens/edit_product_screen.dart';
import 'package:eshop/Screens/product_screens/product_details_screen.dart';
import 'package:eshop/Screens/product_screens/user_product_screen_list.dart';
import 'package:eshop/Screens/auth/auth_screen.dart';
import 'package:eshop/Screens/order_screen.dart';
import 'package:eshop/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/cart.dart';
import 'Screens/splash_screen.dart';
import 'Screens/product_screens/products_overview_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (context) => ProductsProvider('', '', []),
          update: (context, auth, previousProducts) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.item),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            // backgroundColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder()
              },
            ),
          ),
          title: 'My Shop',
          home: auth.isAuth
              ? const ProductsOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          routes: {
            ProductsOverViewScreen.routeName: (context) =>
                const ProductsOverViewScreen(),
            ProductsDetailsScreen.routeName: (context) =>
                const ProductsDetailsScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            UserProductScreen.routeName: (context) => const UserProductScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
