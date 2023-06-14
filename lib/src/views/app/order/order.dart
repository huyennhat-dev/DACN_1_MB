import 'package:flutter/material.dart';

import '../component/header.dart';
import 'order_body.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          AppHeader(
              acctionLeft: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/logo_2.png'),
                  fit: BoxFit.cover),
            ),
          )),
          const SizedBox(height: 10),
          const OrderBody()
        ],
      ),
    );
  }
}
