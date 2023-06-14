import 'package:app_client/src/views/app/bloc/cart_bloc.dart';
import 'package:app_client/src/views/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/user_bloc.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key, this.acctionLeft});

  final Widget? acctionLeft;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final TextEditingController inputController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: 55,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: kDefautPadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [Shadown.shadown],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _actionLeft(context),
          _searchForm(context, size),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            return state.user.sId != null
                ? GestureDetector(
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    child: Stack(
                      children: [
                        _iconButton(Icons.shopping_bag_outlined, 24,
                            () => Scaffold.of(context).openEndDrawer()),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            return Positioned(
                                top: 2,
                                right: 2,
                                child: state.carts.isNotEmpty
                                    ? Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: kPrimaryColor,
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 0)),
                                            ]),
                                        child: Center(
                                          child: Text(
                                            state.carts.length.toString(),
                                            style: GoogleFonts.openSans(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Container());
                          },
                        ),
                      ],
                    ),
                  )
                : Container();
          }),
          const SizedBox(width: 5),
          _iconButton(Icons.menu, 26, () => Scaffold.of(context).openDrawer()),
        ],
      ),
    );
  }

  SizedBox _iconButton(IconData icon, double size, VoidCallback onPressed) =>
      SizedBox(
        height: 40,
        width: 40,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: size),
        ),
      );

  Widget _searchForm(BuildContext context, Size size) => Expanded(
        flex: 1,
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: kDefautPadding / 2),
          margin: const EdgeInsets.symmetric(horizontal: kDefautPadding / 2),
          decoration: BoxDecoration(
              border: Border.all(color: kBorderColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            cursorColor: textColor,
            controller: inputController,
            style: GoogleFonts.openSans(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w400),
            maxLines: 1,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/search',
                        arguments: {"value": inputController.text});
                  },
                  child: const Icon(CupertinoIcons.search,
                      color: textColor, size: 20)),
              border: InputBorder.none,
              hintStyle: GoogleFonts.openSans(
                  color: textColor.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              hintText: "Bạn muốn tìm gì?",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 11, horizontal: 0),
            ),
            onChanged: (value) {},
            onFieldSubmitted: (value) {
              Navigator.pushNamed(context, '/search',
                  arguments: {"value": value});
            },
          ),
        ),
      );

  Widget _actionLeft(BuildContext context) => SizedBox(
      width: 50,
      height: 50,
      child: widget.acctionLeft != null
          ? widget.acctionLeft!
          : _iconButton(
              Icons.arrow_back_ios, 26, () => Navigator.pop(context)));
}
