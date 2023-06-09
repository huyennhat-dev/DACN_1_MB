import 'package:app_client/src/views/app/bloc/cart_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../util/behavior.dart';
import '../../../util/button.dart';
import '../../constants.dart';

class CartBody extends StatelessWidget {
  CartBody({super.key, required this.cartBloc});

  final CartBloc cartBloc;
  final currencyFormatter = NumberFormat.currency(locale: 'vi');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints.expand(),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.carts.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  _buildCartItem(size, cartBloc, state.carts[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartItem(Size size, cartBloc, data) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(60, 0, 0, 0),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: data.product.photos[0],
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  // placeholder: (context, url) => Container(
                  //   height: 80,
                  //   width: 80,
                  //   child: SkeletonParagraph(
                  //     style: SkeletonParagraphStyle(
                  //         lines: 1,
                  //         lineStyle: SkeletonLineStyle(
                  //           height: 80,
                  //           width: 80,
                  //           borderRadius: BorderRadius.circular(5),
                  //         )),
                  //   ),
                  // ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: kPrimaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: kDefautPadding / 2, top: kDefautPadding / 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.85 - 160,
                    child: Text(
                      data.product.name,
                      style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        text: currencyFormatter.format((data.product.price -
                            (data.product.price * data.product.sale))),
                        style: GoogleFonts.openSans(
                          color: Colors.black, // Text color
                          fontSize: 16, // Font size
                          fontWeight: FontWeight.w600, // Font weight
                        ),
                        children: [
                          const TextSpan(text: "  "),
                          TextSpan(
                            text: currencyFormatter.format(data.product.price),
                            style: GoogleFonts.openSans(
                                color: Colors.black54, // Text color
                                fontSize: 13, // Font size
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.lineThrough),
                          )
                        ]),
                  ),
                  Row(
                    children: [
                      CustomButton(
                        height: 25,
                        width: 25,
                        onPressed: () {
                          cartBloc.add(UpdateCartItemEvent(
                              product: data.product, number: -1));
                        },
                        padding: 0,
                        radius: 50,
                        color: Colors.black54,
                        icon: Icons.remove,
                      ),
                      Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: kBorderColor, width: 1)),
                        child: Center(
                            child: Text(
                          data.quantity.toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor),
                        )),
                      ),
                      CustomButton(
                        height: 25,
                        width: 25,
                        onPressed: () => cartBloc.add(UpdateCartItemEvent(
                            product: data.product, number: 1)),
                        padding: 0,
                        radius: 50,
                        color: Colors.black54,
                        icon: Icons.add,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
                height: 40,
                width: 40,
                child: CustomButton(
                  height: 40,
                  width: 40,
                  onPressed: () =>
                      cartBloc.add(RemoveFromCartEvent(data.product)),
                  padding: 0,
                  icon: Icons.delete_outline_outlined,
                  iconSize: 25,
                ))
          ],
        ),
      );
}
