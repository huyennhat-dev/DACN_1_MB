import 'package:app_client/src/controller/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/behavior.dart';
import '../bloc/home_bloc.dart';
import 'component/carousel/carousel.dart';
import '../component/header.dart';
import 'component/list_products/list_products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeListProductBloc homeListProductBloc = HomeListProductBloc();

  @override
  void initState() {
    getRecommendProduct();
    super.initState();
  }

  getRecommendProduct() {
    homeListProductBloc.add(GetRecommendProduct());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BlocProvider(
        create: (context) => homeListProductBloc,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                flexibleSpace: AppHeader(
                    acctionLeft: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo_2.png'),
                        fit: BoxFit.cover),
                  ),
                )),
                automaticallyImplyLeading: false,
                actions: [Container()],
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 10),
                sliver: SliverToBoxAdapter(
                  child: AppCarousel(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: BlocBuilder<HomeListProductBloc, HomeListProductState>(
                    builder: (context, state) {
                      return Products(
                          title: "Sản phẩm bán chạy", products: state.products);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
