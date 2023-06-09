import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/auth.dart';
import 'app/bloc/cart_bloc.dart';
import 'app/bloc/user_bloc.dart';
import 'app/checkout/checkout.dart';
import 'app/home/search.dart';
import 'app/index.dart';
import 'app/home/product.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserBloc userBloc = UserBloc();
  final CartBloc cartBloc = CartBloc();
  @override
  void initState() {
    checkLogged();

    super.initState();
  }

  Future<void> checkLogged() async {
    final UserState? user = await AuthController().logged();
    if (user != null) {
      userBloc.add(LoginEvent(id: user.id, name: user.name, photo: user.photo));
      cartBloc.add(FetchCartEvent());
    } else {
      userBloc.add(LogoutEvent());
    }
  }

  final Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeLayout(),
    '/product': (context) => const ProductDetail(),
    '/search': (context) => const SearchPage(),
    '/checkout': (context) => const CheckOutPage(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => userBloc,
      child: BlocProvider(
        create: (context) => cartBloc,
        child: MaterialApp(
          title: 'BookVN',
          initialRoute: '/',
          routes: routes,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
