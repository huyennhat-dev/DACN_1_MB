import 'package:flutter/material.dart';

import 'app/index.dart';
import 'app/product/product.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeLayout(),
    '/product': (context) => const ProductDetail(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookVN',
      initialRoute: '/',
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
