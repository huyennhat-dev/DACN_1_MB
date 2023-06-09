import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../helper/google_sign_in.dart';
import '../helper/shared_pref.dart';
import '../repo/auth.dart';
import '../views/app/bloc/user_bloc.dart';

class AuthController {
  Future<bool> loginWithGoogle() async {
    final user = await GoogleSignInApi.login();
    if (user != null) {
      final rs = await AuthRepo.googleSignIn({
        "email": user.email,
        "name": user.displayName,
        "photo": user.photoUrl
      });
      final data = jsonDecode(rs.toString());
      await SharedPref().save('uToken', data["token"]);
    }
    return true;
  }

  Future<UserState?> logged() async {
    final String? uToken = await SharedPref().read("uToken");

    if (uToken != null) {
      final data = JWT.decode(uToken).payload;

      final int? tokenExpiration = data.containsKey("exp") ? data["exp"] : null;
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (tokenExpiration != null && tokenExpiration > currentTimestamp) {
        return UserState(
          id: data["sub"]["id"] ?? "",
          name: data["sub"]["name"] ?? "",
          photo: data["sub"]["photo"] ?? "",
        );
      }
    }
    return null;
  }

  Future<void> logout() async {
    await SharedPref().remove("uToken");
    final String? uToken = await SharedPref().read("uToken");
    print(uToken);
  }
}
