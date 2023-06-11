// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:app_client/src/model/cart.dart';
import 'package:app_client/src/repo/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../util/behavior.dart';
import '../../../util/button.dart';
import '../../../util/flush_bar.dart';
import '../../constants.dart';
import '../bloc/cart_bloc.dart';
import '../component/cart_body.dart';
import '../component/cart_drawer.dart';
import '../component/header.dart';
import '../component/menu_drawer.dart';
import 'select_payment_bloc.dart';
import 'web_view.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

const List<Object> paymentMethod = <Object>[
  {"title": 'Thanh toán khi nhận hàng', "val": 'COD'},
  {"title": 'Cổng thanh toán VNPAYQR', "val": 'VNP'}
];

class _CheckOutPageState extends State<CheckOutPage> {
  SelectPaymentBloc selectPaymentBloc = SelectPaymentBloc();
  final currencyFormatter = NumberFormat.currency(locale: 'vi');

  Future<void> checkOut(BuildContext context) async {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    if (cartBloc.state.carts.isEmpty) {
      return FlushBar()
          .showFlushBar(context, "warning", "Chưa có mặt hàng nào!");
    }
    switch (selectPaymentBloc.key) {
      case "":
        FlushBar()
            .showFlushBar(context, "warning", "Phương thức thanh toán trống!");
        break;
      case "COD":
        FlushBar().showFlushBar(
            context, "warning", "Phương thức thanh toán này không hỗ trợ!");
        break;
      case "VNP":
        List<Map<String, dynamic>> products = [];
        final List<Cart> carts = cartBloc.state.carts;
        for (int i = 0; i < carts.length; i++) {
          final product = carts[i].product;
          if (product != null) {
            final price = product.price;
            final sale = product.sale ?? 0.0;
            final data = {
              "product": product.sId,
              "quantity": carts[i].quantity,
              "price": price! - (price * sale)
            };
            products.add(data);
          }
        }

        final rs = await CartRepo.vnpayMethod({
          "products": products,
          "totalPrice": cartBloc.state.totalPrice,
          "paymentMethod": "VNP"
        });

        final String vnpUrl = rs.data['vnpUrl'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyWebView(url: vnpUrl),
          ),
        );
        cartBloc.add(ClearCartEvent());

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
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
              SliverPadding(
                padding: const EdgeInsets.only(top: 10),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefautPadding / 2),
                    child: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.all(kDefautPadding / 2),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kDefautPadding / 2),
                            color: Colors.white,
                          ),
                          child: cartBloc.state.carts.isNotEmpty
                              ? Column(
                                  children: state.carts
                                      .map((e) => CartItem(
                                            cartBloc: cartBloc,
                                            data: e,
                                            width: size.width - kDefautPadding,
                                          ))
                                      .toList(),
                                )
                              : Container(
                                  height:
                                      size.height - 55 - 3.5 * kDefautPadding,
                                  alignment: Alignment.center,
                                  child: Center(
                                      child: Lottie.asset(
                                          'assets/json/empty.json')),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              cartBloc.state.carts.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.all(kDefautPadding / 2),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(kDefautPadding / 2),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kDefautPadding / 2),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phương thức thanh toán",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5),
                              StreamBuilder<String>(
                                  stream: selectPaymentBloc.selectPaymentStream,
                                  builder: (context, snapshot) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 40,
                                      width: size.width - 2 * kDefautPadding,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: kBorderColor, width: 1)),
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        value: snapshot.data,
                                        elevation: 16,
                                        hint: Text(
                                          'Chọn phương thức thanh toán',
                                          style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  textColor.withOpacity(0.5)),
                                        ),
                                        isExpanded: true,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: textColor.withOpacity(0.9),
                                        ),
                                        onChanged: (String? value) {
                                          selectPaymentBloc.select(value!);
                                        },
                                        items: paymentMethod
                                            .map<DropdownMenuItem<String>>(
                                                (Object item) {
                                          return DropdownMenuItem<String>(
                                            value: (item
                                                as Map<String, dynamic>)['val'],
                                            child: Text((item)['title']),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }),
                              const SizedBox(height: 5),
                              const Divider(color: kBorderColor),
                              const SizedBox(height: 5),
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  return Column(
                                    children: [
                                      _buildCheckOutText(size,
                                          "Tổng tiền hàng :", state.totalPrice),
                                      const SizedBox(height: 5),
                                      _buildCheckOutText(
                                          size, "Phí vận chuyển :", 0),
                                      const SizedBox(height: 5),
                                      _buildCheckOutText(size,
                                          "Tổng tiền hàng :", state.totalPrice),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: size.width - 2 * kDefautPadding,
                                alignment: Alignment.center,
                                child: Center(
                                  child: CustomButton(
                                    onPressed: () => checkOut(context),
                                    width: 150,
                                    height: 40,
                                    icon: Icons.breakfast_dining_outlined,
                                    text: "Đặt hàng",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SliverToBoxAdapter()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckOutText(Size size, String text, double price) => SizedBox(
        width: size.width - 2 * kDefautPadding,
        child: Row(
          children: [
            SizedBox(
              width: (size.width - 2 * kDefautPadding) / 2,
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(
              width: (size.width - 2 * kDefautPadding) / 2,
              child: Text(
                currencyFormatter.format(price),
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            )
          ],
        ),
      );
}
