// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_tab_bloc.dart';
import 'component/cart_drawer.dart';
import 'component/menu_drawer.dart';
import 'home/home.dart';
import 'notification/notification.dart';
import 'order/order.dart';
import 'personal/personal.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final BottomTabBloc _bloc = BottomTabBloc();
  final List<Widget> _pages = [
    const HomePage(),
    const OrderPage(),
    const NotificationPage(),
    const PersonalPage()
  ];

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          actions: [Container()]),
      drawer: const MenuDrawer(),
      endDrawer: Drawer(
          width: size.width * 0.85,
          backgroundColor: Colors.white,
          child: const CartWidget()),
      backgroundColor: Colors.white,
      body: StreamBuilder<int>(
        stream: _bloc.currentIndexStream,
        initialData: _bloc.currentIndex,
        builder: (context, snapshot) => IndexedStack(
          index: snapshot.data ?? 0,
          children: _pages,
        ),
      ),
      bottomNavigationBar: _buildBottomTab(),
    );
  }

  StreamBuilder<int> _buildBottomTab() => StreamBuilder<int>(
        stream: _bloc.currentIndexStream,
        initialData: _bloc.currentIndex,
        builder: (context, snapshot) => Container(
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: NavigationBar(
              backgroundColor: Colors.white,
              selectedIndex: snapshot.data ?? 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              onDestinationSelected: (int newIndex) {
                _bloc.updateCurrentIndex(newIndex);
              },
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(CupertinoIcons.house_fill),
                  icon: Icon(CupertinoIcons.house),
                  label: 'Trang chủ',
                ),
                NavigationDestination(
                  selectedIcon: Icon(CupertinoIcons.archivebox_fill),
                  icon: Icon(CupertinoIcons.archivebox),
                  label: 'Đơn hàng',
                ),
                NavigationDestination(
                  selectedIcon: Icon(CupertinoIcons.bell_fill),
                  icon: Icon(CupertinoIcons.bell),
                  label: 'Thông báo',
                ),
                NavigationDestination(
                  selectedIcon: Icon(CupertinoIcons.person_fill),
                  icon: Icon(CupertinoIcons.person),
                  label: 'Cá nhân',
                ),
              ],
            ),
          ),
        ),
      );
}
