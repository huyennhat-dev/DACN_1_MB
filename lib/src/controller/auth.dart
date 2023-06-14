import 'dart:convert';
import 'package:app_client/src/model/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../helper/google_sign_in.dart';
import '../helper/shared_pref.dart';
import '../repo/auth.dart';

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

  Future<User?> logged() async {
    final String? uToken = await SharedPref().read("uToken");

    if (uToken != null) {
      final data = JWT.decode(uToken).payload;

      final int? tokenExpiration = data.containsKey("exp") ? data["exp"] : null;
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (tokenExpiration != null && tokenExpiration > currentTimestamp) {
        return User(sId: data["sub"]["id"] ?? "");
      }
    }
    return null;
  }

  Future<void> logout() async {
    await SharedPref().remove("uToken");
  }
}
