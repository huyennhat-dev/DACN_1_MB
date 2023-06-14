import 'package:app_client/src/util/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../util/behavior.dart';
import '../../constants.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/user_bloc.dart';
import '../component/cart_drawer.dart';

import '../component/menu_drawer.dart';
import 'component/list_products/product_item.dart';
import 'component/search/search_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _page = 1;

  SearchBloc searchBloc = SearchBloc();
  final TextEditingController textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      searchBloc.add(LoadProduct(searchValue: arguments['value'], page: _page));
      textEditingController.text = arguments['value'];
    });
    _scrollController.addListener(_loadMore);
    super.initState();
  }

  void _loadMore() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      searchBloc.add(
          LoadMoreProduct(searchValue: textEditingController.text, page: 2));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
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
        body: BlocProvider(
          create: (context) => searchBloc,
          child: Container(
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
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    flexibleSpace: Container(
                      height: 55,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefautPadding / 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [Shadown.shadown],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _actionLeft(context),
                          _searchForm(context, size),
                          BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) => state.user.sId !=
                                      null
                                  ? GestureDetector(
                                      onTap: () =>
                                          Scaffold.of(context).openEndDrawer(),
                                      child: Stack(
                                        children: [
                                          _iconButton(
                                              Icons.shopping_bag_outlined,
                                              24,
                                              () => Scaffold.of(context)
                                                  .openEndDrawer()),
                                          BlocBuilder<CartBloc, CartState>(
                                            builder: (context, state) {
                                              return Positioned(
                                                  top: 2,
                                                  right: 2,
                                                  child: state.carts.isNotEmpty
                                                      ? Container(
                                                          height: 15,
                                                          width: 15,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 5,
                                                                  offset:
                                                                      Offset(
                                                                          0, 0),
                                                                ),
                                                              ]),
                                                          child: Center(
                                                            child: Text(
                                                              state.carts.length
                                                                  .toString(),
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        )
                                                      : Container());
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()),
                          const SizedBox(width: 5),
                          _iconButton(Icons.menu, 26,
                              () => Scaffold.of(context).openDrawer()),
                        ],
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    actions: [Container()],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 10),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                          width: size.width,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(kDefautPadding / 2),
                          child: BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width - 20,
                                    child: Text(
                                      "Sách đã tìm thấy",
                                      style: GoogleFonts.openSans(
                                          color: textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: state.products
                                        .map((e) => ProductItem(product: e))
                                        .toList(),
                                  ),
                                  state.isLoading
                                      ? Center(
                                          child: Container(
                                              width: size.width,
                                              height: 100,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                              ),
                                              child: Center(
                                                child: LoadingAnimationWidget
                                                    .dotsTriangle(
                                                        color: kPrimaryColor,
                                                        size: 60),
                                              )),
                                        )
                                      : Container()
                                ],
                              );
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  SizedBox _iconButton(IconData icon, double size, VoidCallback onPressed) =>
      SizedBox(
        height: 40,
        width: 40,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: size),
        ),
      );

  Widget _searchForm(BuildContext context, Size size) => Expanded(
        flex: 1,
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: kDefautPadding / 2),
          margin: const EdgeInsets.symmetric(horizontal: kDefautPadding / 2),
          decoration: BoxDecoration(
              border: Border.all(color: kBorderColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            cursorColor: textColor,
            controller: textEditingController,
            style: GoogleFonts.openSans(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w400),
            maxLines: 1,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                  onTap: () {
                    searchBloc.add(LoadProduct(
                        searchValue: textEditingController.text, page: 1));
                  },
                  child: const Icon(CupertinoIcons.search,
                      color: textColor, size: 20)),
              border: InputBorder.none,
              hintStyle: GoogleFonts.openSans(
                  color: textColor.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              hintText: "Bạn muốn tìm gì?",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 11, horizontal: 0),
            ),
            onChanged: (value) {},
            onFieldSubmitted: (value) {
              searchBloc.add(LoadProduct(searchValue: value, page: 1));
            },
          ),
        ),
      );

  Widget _actionLeft(BuildContext context) => SizedBox(
      width: 50,
      height: 50,
      child:
          _iconButton(Icons.arrow_back_ios, 26, () => Navigator.pop(context)));
}
