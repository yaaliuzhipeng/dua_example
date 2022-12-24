import '../stack/dua_stack_navigation.dart';
import 'package:flutter/material.dart';

class DefaultUnknown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Page Not Found", style: TextStyle(fontSize: 26, color: Color(0xFF000000))),
          TextButton(
              onPressed: () {
                DuaStackNavigation.of(context).goBack();
              },
              child: const Text("Go Back", style: TextStyle(fontSize: 16, color: Colors.blue))),
        ],
      ),
    ));
  }
}

var buildDefaultUnknownRouteFactory = (settings) => MaterialPageRoute(
      settings: const RouteSettings(name: '/404'),
      builder: ((context) => DefaultUnknown()),
    );
