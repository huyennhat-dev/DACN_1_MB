import 'package:flutter_html/flutter_html.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants.dart';

class ProductDeltailDesc extends StatelessWidget {
  const ProductDeltailDesc({super.key, this.desc});

  final String? desc;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - kDefautPadding,
      padding: const EdgeInsets.symmetric(
          vertical: kDefautPadding / 1, horizontal: kDefautPadding * 1),
      margin: const EdgeInsets.only(
        bottom: kDefautPadding / 1,
        left: kDefautPadding / 2,
        right: kDefautPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefautPadding / 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Giới thiệu về cuốn sách",
            style: GoogleFonts.openSans(
                fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
          ),
          Html(
            data: desc,
            style: {
              "body": Style(
                  fontSize: const FontSize(14.0),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'OpenSans',
                  color: textColor,
                  wordSpacing: 2)
            },
          ),
        ],
      ),
    );
  }
}
