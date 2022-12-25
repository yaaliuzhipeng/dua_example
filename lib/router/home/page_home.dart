import 'package:dua_example/dua/lib/navigation.dart';
import 'package:dua_example/router/home/store/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> with DuaNavigationFocusMixin, DuaNavigationAutoReleaseMixin {
  final style = const TextStyle(fontSize: 18, color: Colors.blue);

  @override
  String name() => "home";

  @override
  List makeAutoReleaseResource() {
    return [
      HomeStore(),
    ];
  }

  @override
  void initState() {
    loadNavigationFocus();
    loadNavigationAutoRelease();
    super.initState();
  }

  @override
  void onFocusChanged(bool focused) {
    debugPrint("Page ${name()}，当前${focused ? '获得' : '失去'}焦点");
  }

  @override
  void dispose() {
    super.dispose();
    disposeNavigationFocus();
    disposeNavigationAutoRelease();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Page Home"),
            TextButton(
              onPressed: () {
                DuaStackNavigationDelegate.of(context).navigate('user');
              },
              child: Text("navigate to user", style: style),
            )
          ],
        ),
      ),
    );
  }
}
