import 'package:dua_example/dua/lib/dua.dart';
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
  String get name => "home";

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
    debugPrint("Page ${name}，当前${focused ? '获得' : '失去'}焦点");
  }

  @override
  void dispose() {
    super.dispose();
    disposeNavigationFocus();
    disposeNavigationAutoRelease();
  }

  @override
  Widget build(BuildContext context) {
    var store = find<HomeStore>();
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
            O(() {
              return Text(store.text.value, style: const TextStyle(fontSize: 20, color: Colors.pink));
            }),
            O(() {
              return Text(store.user.value.toString(), style: const TextStyle(fontSize: 20, color: Colors.pink));
            }, [store.user]),
            TextButton(
              onPressed: () {
                var store = find<HomeStore>();
                store.setText("hello world");
              },
              child: Text("update text", style: style),
            ),
            TextButton(
              onPressed: () {
                var store = find<HomeStore>();
                User user = store.user.value as User;
                user.id = 666;
                store.setUser(user);
              },
              child: Text("update user", style: style),
            ),
            TextButton(
              onPressed: () {
                "user".go();
              },
              child: Text("navigate to user", style: style),
            ),
          ],
        ),
      ),
    );
  }
}
