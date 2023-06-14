import 'package:app_client/src/util/button.dart';
import 'package:app_client/src/views/app/bloc/cart_bloc.dart';
import 'package:app_client/src/views/app/bloc/counter_bloc.dart';
import 'package:app_client/src/views/app/home/component/product_body/product_body_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:skeletons/skeletons.dart';

import '../../../../../model/product.dart';
import '../../../../../util/behavior.dart';
import '../../../../constants.dart';

class ProductDetailBody extends StatefulWidget {
  const ProductDetailBody({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody> {
  final ProductBodyBloc _bloc = ProductBodyBloc();
  final CounterBloc _counterBloc = CounterBloc();

  void addToCart(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(AddToCartEvent(
        product: widget.product, quantity: _counterBloc.quantity));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi');

    final Size size = MediaQuery.of(context).size;
    final TextStyle textStyle = GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w500, color: textColor);
    final TextStyle textPrimaryStyle = GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w500, color: kPrimaryColor);
    final TextStyle textSecondaryStyle = GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w400, color: kButtonColor);
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(kDefautPadding / 2),
      child: Container(
        width: size.width - kDefautPadding,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(kDefautPadding / 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefautPadding / 2),
        ),
        child: widget.product.sId != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: size.width - 2 * kDefautPadding,
                      height: size.width - 2 * kDefautPadding,
                      margin:
                          const EdgeInsets.only(bottom: kDefautPadding / 1.5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(kDefautPadding / 4),
                          boxShadow: [Shadown.shadown]),
                      child: StreamBuilder<int>(
                          stream: _bloc.imageIndexStream,
                          initialData:
                              0, // Provide initial data for the image index
                          builder: (context, snapshot) => _buildImage(
                              size.width - 2 * kDefautPadding,
                              widget.product.photos![snapshot.data ?? 0]))),
                  SizedBox(
                    width: size.width - 2 * kDefautPadding,
                    height: size.width / 5 + 4,
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                        itemCount: widget.product.photos!.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => _bloc.changeImageIndex(index),
                          child: StreamBuilder<Object>(
                            stream: _bloc.imageIndexStream,
                            initialData: _bloc.currentIndex,
                            builder: (context, snapshot) => Container(
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.only(
                                  right: kDefautPadding / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: snapshot.data == index
                                      ? Border.all(
                                          color: kPrimaryColor, width: 1)
                                      : null),
                              child: _buildImage(size.width / 5,
                                  widget.product.photos![index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefautPadding / 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width - kDefautPadding * 3,
                          child: Text(
                            widget.product.name!,
                            style: GoogleFonts.openSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                        ),
                        Row(
                          children: [
                            RatingBarIndicator(
                                rating: widget.product.star!,
                                itemBuilder: (context, index) =>
                                    const Icon(Icons.star, color: Colors.amber),
                                itemCount: 5,
                                itemSize: 24,
                                itemPadding: const EdgeInsets.only(right: 5),
                                direction: Axis.horizontal),
                            const SizedBox(width: 5),
                            Text(
                              "(60 đánh giá) | Đã bán ${widget.product.purchases}",
                              style: textSecondaryStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                              text: "Tác giả : ",
                              style: textStyle,
                              children: [
                                TextSpan(
                                    text: widget.product.author,
                                    style: textPrimaryStyle)
                              ]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currencyFormatter.format((widget.product.price! -
                              (widget.product.price! * widget.product.sale!))),
                          style: GoogleFonts.openSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryColor),
                        ),
                        if (widget.product.sale! > 0)
                          const SizedBox(height: 10),
                        if (widget.product.sale! > 0)
                          RichText(
                            text: TextSpan(
                                text: "Tiết kiệm: ",
                                style: textStyle,
                                children: [
                                  TextSpan(
                                    text:
                                        "${currencyFormatter.format(widget.product.price! * widget.product.sale!)}  (giảm ${(widget.product.sale! * 100).toStringAsFixed(0)}%)",
                                    style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: kPrimaryColor),
                                  )
                                ]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (widget.product.sale! > 0) const SizedBox(height: 5),
                        if (widget.product.sale! > 0)
                          RichText(
                            text: TextSpan(
                                text: "Giá niêm yết : ",
                                style: textStyle,
                                children: [
                                  TextSpan(
                                    text: currencyFormatter
                                        .format(widget.product.price),
                                    style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: kButtonColor,
                                        decoration: TextDecoration.lineThrough),
                                  )
                                ]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                              text: "Tình trạng : ",
                              style: textStyle,
                              children: [
                                if (widget.product.quantity! > 10)
                                  TextSpan(
                                      text: "Còn hàng", style: textPrimaryStyle)
                                else if (widget.product.quantity! > 0)
                                  TextSpan(
                                      text: "Sắp hết", style: textPrimaryStyle)
                                else
                                  TextSpan(
                                      text: "Hết hàng", style: textPrimaryStyle)
                              ]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                              text: "Tags : ",
                              style: textStyle,
                              children: [
                                TextSpan(
                                    text: "Tôn Giáo - Tâm Linh",
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF0781E4),
                                    ))
                              ]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        StreamBuilder<int>(
                            stream: _counterBloc.quantityStream,
                            initialData: _counterBloc.quantity,
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: "Số lượng : ",
                                          style: textStyle)),
                                  const SizedBox(width: 10),
                                  CustomButton(
                                    onPressed: () => _counterBloc
                                        .decrease(_counterBloc.quantity),
                                    height: 25,
                                    width: 25,
                                    color: Colors.black87,
                                    icon: Icons.remove,
                                    radius: 50,
                                    padding: 0,
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 70,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: kBorderColor, width: 1)),
                                    child: Center(
                                        child: Text(
                                      snapshot.data.toString(),
                                      style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kPrimaryColor),
                                    )),
                                  ),
                                  const SizedBox(width: 5),
                                  CustomButton(
                                    onPressed: () => _counterBloc
                                        .increase(_counterBloc.quantity),
                                    height: 25,
                                    width: 25,
                                    color: Colors.black87,
                                    icon: Icons.add,
                                    radius: 50,
                                    padding: 0,
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(height: 5),
                        Center(
                          child: CustomButton(
                            onPressed: () => addToCart(context),
                            icon: Icons.shopping_bag_outlined,
                            text: "Thêm vào giỏ hàng",
                            width: (size.width - 2 * kDefautPadding) / 2,
                            height: 40,
                            textSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Thông tin khuyến mãi", style: textStyle),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.gift,
                                color: kPrimaryColor, size: 16),
                            const SizedBox(width: 5),
                            Text("Đổi trả trong vòng 7 ngày",
                                style: textSecondaryStyle),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.gift,
                                color: kPrimaryColor, size: 16),
                            const SizedBox(width: 5),
                            Text("Free ship nội thành Đà Nẵng từ 150.00đ",
                                style: textSecondaryStyle),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.gift,
                                color: kPrimaryColor, size: 16),
                            const SizedBox(width: 5),
                            Text("Free ship toàn quốc từ 350.00đ",
                                style: textSecondaryStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _buildImage(double width, String imgUrl) => ClipRRect(
        borderRadius: BorderRadius.circular(kDefautPadding / 4),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          height: width,
          width: width,
          fit: BoxFit.cover,
          // placeholder: (BuildContext context, String url) => SkeletonParagraph(
          //   style: SkeletonParagraphStyle(
          //       lines: 1,
          //       lineStyle: SkeletonLineStyle(
          //           height: width,
          //           width: width,
          //           borderRadius: BorderRadius.circular(kDefautPadding / 2))),
          // ),
          errorWidget: (context, url, error) => Container(
            alignment: Alignment.center,
            child: const Icon(Icons.error, color: kErrorColor),
          ),
        ),
      );
}
