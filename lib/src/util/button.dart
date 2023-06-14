import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../views/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      this.height = 30,
      this.width = 30,
      this.text,
      this.icon,
      this.radius = 5.0,
      this.iconSize = 20,
      this.padding,
      this.color = kPrimaryColor,
      this.textSize = 16});

  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? radius;
  final String? text;
  final IconData? icon;
  final double? iconSize;
  final double? textSize;
  final double? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: padding != null
            ? MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(padding!))
            : null,
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return color!.withOpacity(0.1);
            }
            return color!.withOpacity(0.1);
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
        ),
        maximumSize: MaterialStateProperty.all<Size>(Size(width!, height!)),
        minimumSize: MaterialStateProperty.all<Size>(Size(width!, height!)),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: color!, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null ? Icon(icon, color: color, size: iconSize) : Container(),
          text != null
              ? Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    text!,
                    style: GoogleFonts.openSans(
                        color: color,
                        fontSize: textSize,
                        fontWeight: FontWeight.w500),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
