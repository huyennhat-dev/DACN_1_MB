import 'package:app_client/src/model/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:skeletons/skeletons.dart';

import '../../../../../util/button.dart';
import '../../../../constants.dart';
import '../../../bloc/cart_bloc.dart';

class ProductItem extends StatelessWidget {
  ProductItem({super.key, this.product});

  final Product? product;

  final currencyFormatter = NumberFormat.currency(locale: 'vi');

  void addToCart(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(AddToCartEvent(product: product!, quantity: 1));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double width = (size.width - 30) / 2;
    if (size.width > 576) {
      width = (size.width - 40) / 3;
    }
    return Container(
      width: width,
      height: width * 1.75,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/product',
            arguments: {"pId": product!.sId}),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(width),
            _buildBody(context, width),
            _buildButton(context, width)
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, double width) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: kDefautPadding / 1.5),
        child: CustomButton(
          onPressed: () => addToCart(context),
          width: width - 40,
          height: 35,
          icon: Icons.shopping_bag_outlined,
          text: "Thêm vào giỏ",
        ),
      );

  Widget _buildBody(BuildContext context, double width) => Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              product!.name.toString(),
              style: GoogleFonts.openSans(
                  fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product!.star.toString(),
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor.withOpacity(0.7)),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.star,
                  size: 15,
                  color: Color(0xFFFFDE3B),
                ),
                const SizedBox(width: 5),
                Text(
                  "| Đã bán ${product!.purchases}",
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor.withOpacity(0.7)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  currencyFormatter.format(
                      product!.price! - (product!.price! * product!.sale!)),
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                ),
                const SizedBox(width: 5),
                Text(
                  product!.sale! > 0
                      ? "- ${(product!.sale! * 100).toStringAsFixed(0)}%"
                      : "",
                  style: GoogleFonts.openSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor),
                ),
              ],
            )
          ],
        ),
      );

  Widget _buildImage(double width) => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: product!.photos![0],
          fit: BoxFit.cover,
          height: width - 10,
          width: width - 10,
          // placeholder: (BuildContext context, String url) => SkeletonParagraph(
          //   style: SkeletonParagraphStyle(
          //       lineStyle: SkeletonLineStyle(
          //     height: width - 10,
          //     width: width - 10,
          //     borderRadius: BorderRadius.circular(7),
          //   )),
          // ),
          errorWidget: (context, url, error) => Container(
            alignment: Alignment.center,
            child: const Icon(
              Icons.error,
              color: kErrorColor,
            ),
          ),
        ),
      );
}
