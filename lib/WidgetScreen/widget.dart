import 'package:shared_preferences/shared_preferences.dart';

class WidgetScreen {
  Future gettoken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String uid = sp.getString("uid") ?? "";

    return uid.isEmpty ? true : false;
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("uid");
    return true;
  }
}
