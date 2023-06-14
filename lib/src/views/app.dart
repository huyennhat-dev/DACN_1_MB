import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/auth.dart';
import '../model/user.dart';
import '../repo/auth.dart';
import 'app/bloc/cart_bloc.dart';
import 'app/bloc/user_bloc.dart';
import 'app/checkout/checkout.dart';
import 'app/home/search.dart';
import 'app/index.dart';
import 'app/home/product.dart';
import 'app/order/order_tab_bloc.dart';
import 'app/personal/edit_profile.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserBloc userBloc = UserBloc();
  final CartBloc cartBloc = CartBloc();
  final OrderTabBloc orderTabBloc = OrderTabBloc();
  @override
  void initState() {
    checkLogged();

    super.initState();
  }

  Future<void> checkLogged() async {
    final User? user = await AuthController().logged();
    if (user != null) {
      final rs = await AuthRepo.getInfo();
      userBloc.add(LoginEvent(
          user: User(
              sId: user.sId,
              name: rs.data['user']['name'],
              photo: rs.data['user']['photo'],
              email: rs.data['user']['email'],
              address: rs.data['user']['address'],
              phone: rs.data['user']['phone'])));
      cartBloc.add(FetchCartEvent());
      orderTabBloc.add(LoadOrderTabEvent());
    } else {
      userBloc.add(LogoutEvent());
    }
  }

  final Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeLayout(),
    '/product': (context) => const ProductDetail(),
    '/search': (context) => const SearchPage(),
    '/checkout': (context) => const CheckOutPage(),
    '/edit-profile': (context) => const EditProfile(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) => userBloc,
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) => cartBloc,
        ),
        BlocProvider<OrderTabBloc>(
          create: (BuildContext context) => orderTabBloc,
        ),
      ],
      child: MaterialApp(
        title: 'BookVN',
        initialRoute: '/',
        routes: routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
