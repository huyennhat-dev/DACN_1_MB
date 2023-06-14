import 'package:app_client/src/util/behavior.dart';
import 'package:app_client/src/views/app/bloc/user_bloc.dart';
import 'package:app_client/src/views/app/order/order_tab_bloc.dart';
import 'package:app_client/src/views/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../model/order.dart';

class OrderBody extends StatefulWidget {
  const OrderBody({super.key});

  @override
  State<OrderBody> createState() => _OrderBodyState();
}

class _OrderBodyState extends State<OrderBody> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi');
  final formattedTime = DateFormat('HH:mm d-M-yyyy');
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    final orderTabBloc = BlocProvider.of<OrderTabBloc>(context);

    orderTabBloc.add(LoadOrderTabEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width - kDefautPadding,
      padding: const EdgeInsets.symmetric(vertical: kDefautPadding / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefautPadding / 2),
        color: Colors.white,
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return state.user.sId != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefautPadding / 2),
                      child: Text(
                        'Danh sách đơn hàng',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    _buildTabHeader(context, size),
                    _buildTabBody(context, size)
                  ],
                )
              : Container(
                  height: size.height - 2 * 55 - 3 * kDefautPadding,
                );
        },
      ),
    );
  }

  Widget _buildTabBody(BuildContext context, Size size) {
    final orderTabBloc = BlocProvider.of<OrderTabBloc>(context);

    return SizedBox(
      height: size.height - 55 - kDefautPadding - 160,
      child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: BlocBuilder<OrderTabBloc, OrderTabtState>(
            builder: (context, state) {
              return PageView.builder(
                controller:
                    PageController(initialPage: state.selectTabIndex ?? 0),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (int page) =>
                    orderTabBloc.add(ChangeTabEvent(selectTabIndex: page)),
                itemCount: state.orderStatus!.length,
                itemBuilder: (context, index) {
                  final List<Order> orders = state.orders!
                      .where((order) =>
                          order.orderStatus!.slug ==
                          state.orderStatus![index].slug)
                      .toList();

                  return Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: orders.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) => orders.isNotEmpty
                          ? _buildTabBodyItem(size, i, orders[i])
                          : Container(),
                    ),
                  );
                },
              );
            },
          )),
    );
  }

  Widget _buildTabBodyItem(Size size, int itemIndex, Order data) {
    TextStyle textStyle = GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w400, color: textColor);
    return Container(
      width: size.width - 2 * kDefautPadding,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [Shadown.shadown],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: kBorderColor, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: kBorderColor, width: 1),
                    ),
                    child: Center(
                      child: Text((itemIndex + 1).toString(), style: textStyle),
                    )),
                Text(formattedTime.format(DateTime.parse(data.createdAt!)),
                    style: textStyle)
              ],
            ),
          ),
          const SizedBox(height: 5),
          for (int i = 0; i < data.products!.length; i++)
            Container(
              width: size.width - 3 * kDefautPadding,
              margin: const EdgeInsets.only(bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(color: kBorderColor, width: 1)),
                    child: CachedNetworkImage(
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      imageUrl: data.products![i].product!.photos![0],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width - 130,
                        child: Text(
                          data.products![i].product!.name.toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ),
                      ),
                      const SizedBox(height: 3),
                      RichText(
                        text: TextSpan(
                            text: "Giá tiền : ",
                            style: textStyle,
                            children: [
                              TextSpan(
                                  text: currencyFormatter
                                      .format(data.products![i].price),
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kPrimaryColor))
                            ]),
                      ),
                      const SizedBox(height: 3),
                      RichText(
                        text: TextSpan(
                            text: "Số lượng : ",
                            style: textStyle,
                            children: [
                              TextSpan(
                                  text: data.products![i].quantity.toString(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kPrimaryColor))
                            ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          const SizedBox(height: 5),
          const Divider(
            color: kBorderColor,
            height: 1,
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              'Tổng tiền',
              style: GoogleFonts.openSans(
                  fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
            ),
          ),
          Center(
            child: Text(
              currencyFormatter.format(data.totalPrice),
              style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildTabHeader(BuildContext context, Size size) {
    final orderTabBloc = BlocProvider.of<OrderTabBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefautPadding / 2),
      child: Container(
        width: size.width - 2 * kDefautPadding,
        height: 40,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: kBorderColor, width: 1),
          ),
        ),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: BlocBuilder<OrderTabBloc, OrderTabtState>(
            builder: (context, state) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: state.orderStatus!.length,
                itemBuilder: (context, index) => _buildHeaderItem(
                  state.orderStatus![index].name!,
                  index,
                  state.selectTabIndex ?? 0,
                  () => orderTabBloc.add(ChangeTabEvent(selectTabIndex: index)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderItem(
          String text, int index, int selectIndex, VoidCallback onPressed) =>
      GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color:
                      selectIndex == index ? kPrimaryColor : Colors.transparent,
                  width: 1),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: selectIndex == index ? kPrimaryColor : textColor,
            ),
          ),
        ),
      );
}
