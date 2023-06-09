import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color(0xFFff4d4f);
const kSecondaryColor = Color(0xFFf43f5e);
const kTertiaryColor = Color(0xFF1a1a1a);
const kQuaternaryColor = Color(0xFF292929);

const textColor = Color(0xFF000000);
const kButtonColor = Color(0xFF3f3f3f);
const kBorderColor = Color(0xFFd9d9d9);

const kWarninngColor = Color(0xFFF2B40A);
const kErrorColor = Color(0xFFED1616);
const kSuccessColor = Color(0xFF4BB543);

const kDefautPadding = 20;

class SnackBarStyle {
  static TextStyle kTitle = GoogleFonts.mulish(
      color: kTertiaryColor, fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle kMessage = GoogleFonts.mulish(
      color: kTertiaryColor, fontSize: 16, fontWeight: FontWeight.w400);
}

class Shadown {
  static BoxShadow shadown = const BoxShadow(
      color: Color.fromARGB(60, 101, 101, 101),
      blurRadius: 10,
      offset: Offset(0, 0),
      spreadRadius: 1);
}
