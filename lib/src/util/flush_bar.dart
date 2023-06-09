import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../views/constants.dart';

class FlushBar {
  void showFlushBar(BuildContext context, String type, String text) {
    IconData? icon;
    Color? iconColor;
    switch (type) {
      case "success":
        icon = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case "warning":
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.amberAccent;
        break;
      case "error":
        icon = Icons.error_outline;
        iconColor = Colors.redAccent;
        break;
      default:
    }
    showTopSnackBar(
      Overlay.of(context)!,
      CustomSnackBar.success(
        backgroundColor: Colors.white.withOpacity(0.5),
        iconPositionLeft: 20,
        icon: Icon(icon, color: iconColor, size: 40),
        iconRotationAngle: 0,
        message: text,
        messagePadding: const EdgeInsets.only(left: 20),
        textAlign: TextAlign.left,
        textStyle: GoogleFonts.openSans(
            fontSize: 18, fontWeight: FontWeight.w400, color: textColor),
      ),
      padding: const EdgeInsets.all(kDefautPadding / 2),
      animationDuration: const Duration(milliseconds: 1500),
    );
  }
}
