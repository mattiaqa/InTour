import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/Screens/Authentication/Login/login.dart';
import 'package:frontend/profile_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppService extends ChangeNotifier {
  AppService._();

  factory AppService() => _instance;

  static AppService get instance => _instance;
  static final AppService _instance = AppService._();

  final Box storageBox = Hive.box('App Service Box');
  final _kCurrentUserKey = 'current_user';

  final navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;

  Profile_Data? currentUser;

  bool get isLoggedIn => currentUser != null;

  void initialize() {
    final user = storageBox.get(_kCurrentUserKey);
    if (user != null) currentUser = user;
  }

  void setUserData(Profile_Data userData) {
    storageBox.put(_kCurrentUserKey, userData);
    currentUser = userData;
    notifyListeners();
  }

  void manageAutoLogout() {
    terminate();
    context.go(LoginPage.route);
  }

  Future<void> terminate() async {
    currentUser = null;
    storageBox.clear();
  }
}
