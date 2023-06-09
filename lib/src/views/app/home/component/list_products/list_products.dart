import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../model/product.dart';
import '../../../../constants.dart';
import 'product_item.dart';

class Products extends StatelessWidget {
  const Products({super.key, required this.title, required this.products});
  final String title;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefautPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTitle(size),
          const SizedBox(height: 10),
          Wrap(
              spacing: 10,
              runSpacing: 10,
              children: products
                  .map((product) => ProductItem(product: product))
                  .toList())
        ],
      ),
    );
  }

  Widget _buildTitle(Size size) => SizedBox(
        width: size.width - 20,
        child: Text(
          title,
          style: GoogleFonts.openSans(
              color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
