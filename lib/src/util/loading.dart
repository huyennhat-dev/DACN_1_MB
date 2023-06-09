import 'dart:ui';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

import '../views/constants.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: Center(
            child: LoadingAnimationWidget.dotsTriangle(
                color: kPrimaryColor, size: 60),
          )),
    );
  }
}
