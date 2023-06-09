import 'package:app_client/src/util/behavior.dart';
import 'package:app_client/src/util/button.dart';
import 'package:app_client/src/views/app/bloc/cart_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:skeletons/skeletons.dart';

import '../../constants.dart';
import 'cart_body.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final cartBloc = BlocProvider.of<CartBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          _buildHeader(size, context),
          Expanded(flex: 1, child: CartBody(cartBloc: cartBloc)),
          _buildBottom(size)
        ],
      ),
    );
  }

  Widget _buildBottom(Size size) => Container(
        width: size.width - 20,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          top: kDefautPadding / 1.5,
          bottom: kDefautPadding / 2.5,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: kBorderColor, width: 1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return RichText(
                  text: TextSpan(
                    text: 'Tổng tiền : ', // The actual text
                    style: GoogleFonts.openSans(
                      color: Colors.black, // Text color
                      fontSize: 16, // Font size
                      fontWeight: FontWeight.w500, // Font weight
                    ),
                    children: [
                      TextSpan(
                        text: currencyFormatter.format(state.totalPrice),
                        style: const TextStyle(
                          color: kPrimaryColor, // Text color
                          fontSize: 16, // Font size
                          fontWeight: FontWeight.w600, // Font weight
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            CustomButton(
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
              height: 40,
              width: size.width * 0.85 - 150,
              icon: Icons.shopping_bag_outlined,
              text: "Đặt Hàng",
            ),
          ],
        ),
      );

  Widget _buildHeader(Size size, BuildContext context) => Container(
        height: 60,
        width: size.width * 0.85 - 20,
        padding: const EdgeInsets.only(top: kDefautPadding / 1),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: kBorderColor, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Text(
                  'Giỏ hàng',
                  style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hiện tại có ",
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return Text(
                      state.carts.length.toString(),
                      style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor),
                    );
                  },
                ),
                Text(
                  " đơn hàng",
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor),
                ),
              ],
            )
          ],
        ),
      );
}
