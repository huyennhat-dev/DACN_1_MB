import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.85,
      child: Container(
          width: size.width * 0.9,
          child: Center(
            child: Text("Is drawer"),
          )),
    );
  }
}
