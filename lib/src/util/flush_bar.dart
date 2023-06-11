import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../views/constants.dart';

class FlushBar {
  void showFlushBar(BuildContext context, String type, String text) {
    IconData? icon;
    Color? iconColor;
    switch (type) {
      case "success":
        icon = Icons.check_circle_outline;
        iconColor = const Color(0xFF00FF08);
        break;
      case "warning":
        icon = Icons.warning_amber_rounded;
        iconColor = const Color(0xFFFFC800);
        break;
      case "error":
        icon = Icons.error_outline;
        iconColor = const Color(0xFFFF0000);
        break;
      default:
    }
    Flushbar(
      title: "Mê Truyện Chữ!",
      message: text,
      messageText: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          text,
          style: GoogleFonts.openSans(
              fontSize: 15, fontWeight: FontWeight.w400, color: textColor),
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          "Mê Truyện Chữ!",
          style: GoogleFonts.openSans(
              fontSize: 17, fontWeight: FontWeight.w500, color: textColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      icon: Icon(icon, size: 48.0, color: iconColor),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 2000),
      borderRadius: BorderRadius.circular(10),
      animationDuration: const Duration(milliseconds: 700),
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 0), // vertical offset
        ),
      ],
      // backgroundGradient: LinearGradient(
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      //   colors: [
      //     Colors.blue.withOpacity(0.8),
      //     Colors.purple.withOpacity(0.8),
      //   ],
      // ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    ).show(context);
  }
}
