import 'package:app_client/src/views/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: 70,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: kDefautPadding / 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(104, 212, 210, 210),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          _appLogo(),
          _searchForm(size),
          GestureDetector(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            child: Stack(
              children: [
                _iconButton(Icons.shopping_bag_outlined, 24,
                    () => Scaffold.of(context).openEndDrawer()),
                Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.red,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0) // changes position of shadow
                                ),
                          ]),
                      child: Center(
                        child: Text(
                          '9',
                          style: GoogleFonts.openSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    )),
              ],
            ),
          ),
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

  Container _searchForm(Size size) => Container(
        height: 40,
        width: size.width - 175,
        padding: const EdgeInsets.only(left: kDefautPadding / 2),
        margin: const EdgeInsets.symmetric(horizontal: kDefautPadding / 2),
        decoration: BoxDecoration(
            border: Border.all(color: kBorderColor, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
          cursorColor: textColor,
          style: GoogleFonts.openSans(
              color: textColor, fontSize: 16, fontWeight: FontWeight.w400),
          maxLines: 1,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            suffixIcon:
                const Icon(CupertinoIcons.search, color: textColor, size: 20),
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
        ),
      );

  Container _appLogo() => Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/logo_2.png'), fit: BoxFit.cover),
        ),
      );
}
