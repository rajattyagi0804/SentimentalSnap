import 'package:shared_preferences/shared_preferences.dart';

class WidgetScreen {
  Future getSharedprefrenceValue() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String role = sp.getString("role") ?? "";
    final String email = sp.getString("email") ?? "";
    final String uid = sp.getString("uid") ?? "";

    if (role.isNotEmpty) {
      if (role == "Admin") {
        return {"role": "Admin", "email": email, "uid": uid};
      } else {
        return {"role": "User", "email": email, "uid": uid};
      }
    }

    return {"role": ""};
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("uid");
    sp.remove('role');
    sp.remove('email');
    return true;
  }
}
