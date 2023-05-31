import 'package:flutter/material.dart';

import '../../../util/behavior.dart';
import 'component/carousel/carousel.dart';
import 'component/header.dart';
import 'component/products/products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            const SliverPadding(
              padding: EdgeInsets.only(top: 10),
              sliver: SliverToBoxAdapter(
                child: AppCarousel(),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Products(title: "Sản phẩm bán chạy"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
