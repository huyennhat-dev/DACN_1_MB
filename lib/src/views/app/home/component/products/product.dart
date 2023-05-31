import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../constants.dart';

class Product extends StatelessWidget {
  Product({super.key, required this.addToCart});

  final VoidCallback addToCart;

  final currencyFormatter = NumberFormat.currency(locale: 'vi');
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
            arguments: {"name": "hihi"}),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(width),
            _buildBody(context, width),
            _buildButton(width)
          ],
        ),
      ),
    );
  }

  Widget _buildButton(double width) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: kDefautPadding / 1.5),
        child: OutlinedButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.red.withOpacity(0.1);
                }
                return Colors.red.withOpacity(0.1);
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            minimumSize: MaterialStateProperty.all<Size>(Size(width * 0.5, 35)),
            side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(color: Colors.red, width: 1.0),
            ),
          ),
          onPressed: addToCart,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined,
                  color: Colors.red, size: 20),
              const SizedBox(width: 5),
              Text(
                "Thêm vào giỏ",
                style: GoogleFonts.openSans(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
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
              "Điềm Tĩnh Và Nóng Giận ",
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
                  "4.5",
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
                  "| Đã bán 60",
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
                  currencyFormatter.format(100000),
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
                const SizedBox(width: 5),
                Text(
                  "- 25%",
                  style: GoogleFonts.openSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                ),
              ],
            )
          ],
        ),
      );

  Widget _buildImage(double width) => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl:
              "http://res.cloudinary.com/huyennhat/image/upload/v1684695584/images/products/wugq441gligial2pkreh.png",
          fit: BoxFit.cover,
          height: width - 10,
          width: width - 10,
          placeholder: (BuildContext context, String url) => SkeletonParagraph(
            style: SkeletonParagraphStyle(
                lineStyle: SkeletonLineStyle(
              height: width - 10,
              width: width - 10,
              borderRadius: BorderRadius.circular(7),
            )),
          ),
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
