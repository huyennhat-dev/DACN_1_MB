import 'package:app_client/src/util/behavior.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

import '../../constants.dart';

class CartDrawer extends StatelessWidget {
  CartDrawer({super.key});
  final currencyFormatter = NumberFormat.currency(locale: 'vi');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Drawer(
        width: size.width * 0.85,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildHeader(size, context),
              Expanded(flex: 1, child: _buildBody(size)),
              _buildBottom(size)
            ],
          ),
        ));
  }

  Widget _buildBody(Size size) => Container(
        constraints: const BoxConstraints.expand(),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => _buildCartItem(size),
          ),
        ),
      );

  Widget _buildCartItem(Size size) => Container(
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
                  imageUrl:
                      "http://res.cloudinary.com/huyennhat/image/upload/v1684695477/images/products/bwycdwd3lehpiqr5bkgq.png",
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lineStyle: SkeletonLineStyle(
                      height: 80,
                      width: 80,
                      borderRadius: BorderRadius.circular(5),
                    )),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
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
                      "Phải Lòng Với Cô Đơn",
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
                        text: currencyFormatter.format(10000),
                        style: GoogleFonts.openSans(
                          color: Colors.black, // Text color
                          fontSize: 17, // Font size
                          fontWeight: FontWeight.w600, // Font weight
                        ),
                        children: [
                          const TextSpan(text: "  "),
                          TextSpan(
                            text: currencyFormatter.format(10000),
                            style: GoogleFonts.openSans(
                                color: Colors.black54, // Text color
                                fontSize: 14, // Font size
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.lineThrough),
                          )
                        ]),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 26,
                          )),
                      Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: kBorderColor, width: 1)),
                        child: Center(
                            child: Text(
                          "12",
                          style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        )),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_circle_outline,
                            size: 26,
                          ))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 32,
                      color: Colors.red,
                    )))
          ],
        ),
      );

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
            RichText(
              text: TextSpan(
                text: 'Tổng tiền :', // The actual text
                style: GoogleFonts.openSans(
                  color: Colors.black, // Text color
                  fontSize: 16, // Font size
                  fontWeight: FontWeight.w500, // Font weight
                ),
                children: [
                  TextSpan(
                    text: currencyFormatter
                        .format(100000), // Additional text with different style
                    style: const TextStyle(
                      color: Colors.red, // Text color
                      fontSize: 16, // Font size
                      fontWeight: FontWeight.w600, // Font weight
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
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
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                maximumSize: MaterialStateProperty.all<Size>(
                    Size(size.width * 0.85 - 150, 40)),
                side: MaterialStateProperty.all<BorderSide>(
                  const BorderSide(color: Colors.red, width: 1.0),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      color: Colors.red, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    "Đặt hàng",
                    style: GoogleFonts.openSans(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
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
                Text(
                  "1",
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
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
