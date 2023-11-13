// ignore_for_file: use_build_context_synchronously

import 'package:app_client/src/model/user.dart';
import 'package:app_client/src/repo/auth.dart';
import 'package:app_client/src/views/app/order/order_tab_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../controller/auth.dart';
import '../../../util/flush_bar.dart';
import '../../../util/loading.dart';
import '../../constants.dart';
import '../bloc/loading_bloc.dart';
import '../bloc/user_bloc.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final LoadingBloc _loadingBloc = LoadingBloc();

  Future<void> login(BuildContext context) async {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final orderTabBloc = BlocProvider.of<OrderTabBloc>(context);

    _loadingBloc.changeLoading(true);
    bool rs = await AuthController().loginWithGoogle();
    if (rs) {
      final User? user = await AuthController().logged();
      if (user != null) {
        final rs = await AuthRepo.getInfo();
        orderTabBloc.add(LoadOrderTabEvent());

        userBloc.add(LoginEvent(
            user: User(
                sId: user.sId,
                name: rs.data['user']['name'],
                photo: rs.data['user']['photo'],
                email: rs.data['user']['email'],
                address: rs.data['user']['address'],
                phone: rs.data['user']['phone'])));
        FlushBar().showFlushBar(context, "success", "Đăng nhập thành công!");
      } else {
        userBloc.add(LogoutEvent());
      }
    } else {
      FlushBar().showFlushBar(
          context, "warning", "Đăng nhập thất bại! Có lỗi xảy ra.");
    }
    _loadingBloc.changeLoading(false);
  }

  Future<void> logout(BuildContext context) async {
    _loadingBloc.changeLoading(true);
    final userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.add(LogoutEvent());

    AuthController().logout();
    FlushBar().showFlushBar(context, "success", "Đăng xuất thành công!");
    _loadingBloc.changeLoading(false);
  }

  @override
  void dispose() {
    _loadingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final TextStyle textStyle = GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w400, color: textColor);
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(kDefautPadding / 2),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            return state.user.sId != null
                ? _buildLogged(context, size, state)
                : _notLoggedIn(textStyle, context, size);
          }),
          StreamBuilder<bool>(
              stream: _loadingBloc.isLoadingStream,
              builder: (context, snapshot) {
                return _loadingBloc.isLooading
                    ? const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: LoadingWidget(),
                      )
                    : Container();
              })
        ],
      ),
    );
  }

  Widget _buildLogged(BuildContext context, Size size, UserState state) =>
      Container(
        width: size.width - kDefautPadding,
        padding: const EdgeInsets.all(kDefautPadding / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefautPadding / 2),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                border: Border.all(color: kBorderColor, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: CachedNetworkImage(
                  imageUrl: state.user.photo ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width - 2 * kDefautPadding,
              child: Center(
                child: Text(
                  state.user.name ?? "",
                  style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLoggedButton(
                size,
                () => Navigator.pushNamed(context, '/edit-profile'),
                Icons.edit,
                "Chỉnh sửa tài khoản"),
            const SizedBox(height: 20),
            _buildLoggedButton(
              size,
              () => logout(context),
              Icons.logout,
              "Đăng xuất",
            )
          ],
        ),
      );

  Widget _buildLoggedButton(
          Size size, VoidCallback onPressed, IconData icon, String text) =>
      InkWell(
        onTap: onPressed,
        child: Container(
          width: size.width - 6 * kDefautPadding,
          padding: const EdgeInsets.symmetric(
              vertical: kDefautPadding / 2, horizontal: kDefautPadding / 2),
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: kBorderColor, width: 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(
                text,
                style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: textColor),
              )
            ],
          ),
        ),
      );

  Widget _notLoggedIn(TextStyle textStyle, BuildContext context, Size size) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Nhấn vào biểu tượng bên dưới để đăng nhập", style: textStyle),
          GestureDetector(
            onTap: () => login(context),
            child: SizedBox(
                height: size.width / 4,
                width: size.width / 4,
                child: Lottie.asset('assets/json/login.json')),
          ),
        ],
      );
}
