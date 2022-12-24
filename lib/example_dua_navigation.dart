import 'package:dua_example/dua/lib/structure.dart';
import 'package:dua_example/dua/lib/navigation.dart';
import 'package:dua_example/router/home/page_home.dart';
import 'package:dua_example/router/user/page_user.dart';
import 'package:dua_example/router/user/page_user_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const PAGE_HOME = "home";
const PAGE_USER = "user";
const PAGE_USER_DETAIL = "user_detail";

var router;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  router = DuaStackNavigationBuilder.fill(
    initialPage: PAGE_HOME,
    observers: [],
    pages: <DuaStackNavigationPage>[
      buildStackNavigationMaterialPage(PAGE_HOME, Home()),
      buildStackNavigationMaterialPage(PAGE_USER, User()),
      buildStackNavigationMaterialPage(PAGE_USER_DETAIL, UserDetail()),
    ],
  ).build();

  Dio.put<DuaStackNavigation>(router.routerDelegate as DuaStackNavigation);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

buildStackNavigationMaterialPage(String name, Widget child) {
  return DuaStackNavigationPage(name, MaterialPage(child: child, name: name));
}
