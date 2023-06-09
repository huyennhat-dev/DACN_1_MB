import 'package:app_client/src/views/app/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/behavior.dart';
import '../component/cart_drawer.dart';
import '../component/header.dart';
import '../component/menu_drawer.dart';
import 'component/product_body/product_body.dart';
import 'component/product_body/product_desc.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ProductBloc productBloc = ProductBloc();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      productBloc.add(GetProduct(pId: arguments['pId']));
    });
  }

  @override
  void dispose() {
    productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.white,
        ),
        endDrawer: Drawer(
            width: size.width * 0.85,
            backgroundColor: Colors.white,
            child: const CartWidget()),
        drawer: const MenuDrawer(),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocProvider(
            create: (context) => productBloc,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    flexibleSpace: const AppHeader(),
                    automaticallyImplyLeading: false,
                    actions: [Container()],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 10),
                    sliver: SliverToBoxAdapter(child:
                        BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                      return ProductDetailBody(
                        product: state.product,
                      );
                    })),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 0),
                    sliver: SliverToBoxAdapter(
                      child: BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          return ProductDeltailDesc(
                              desc: state.product.description ?? "");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
