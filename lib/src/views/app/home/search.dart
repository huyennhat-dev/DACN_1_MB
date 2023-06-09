import 'package:flutter/material.dart';

import '../../../util/behavior.dart';
import '../component/cart_drawer.dart';
import '../component/header.dart';
import '../component/menu_drawer.dart';
import 'component/search/search_body.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
                    child: SearchBody(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
