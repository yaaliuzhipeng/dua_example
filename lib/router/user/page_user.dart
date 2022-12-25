import 'package:dua_example/dua/lib/structure.dart';
import 'package:dua_example/dua/lib/navigation.dart';
import 'package:dua_example/router/user/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const style = TextStyle(fontSize: 18, color: Colors.blue);

class User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _User();
}

class _User extends State<User> with DuaNavigationFocusMixin, DuaNavigationAutoReleaseMixin {
  @override
  String name() => "user";

  @override
  List makeAutoReleaseResource() {
    return [
      UserStore(),
    ];
  }

  @override
  void onFocusChanged(bool focused) {
    debugPrint("Page ${name()}，当前${focused ? '获得' : '失去'}焦点");
  }

  @override
  void initState() {
    loadNavigationFocus();
    loadNavigationAutoRelease();
    super.initState();
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
            const Text("Page User"),
            TextButton(
              onPressed: () {
                Dio.find<DuaStackNavigationDelegate>()?.navigate('user_detail');
              },
              child: const Text("navigate to user detail", style: style),
            ),
            TextButton(
              onPressed: () {
                DuaStackNavigationDelegate.of(context).navigate('user_detail', forResult: true);
              },
              child: Text("navigate to user detail for result", style: style),
            ),
            TextButton(
              onPressed: () {
                DuaStackNavigationDelegate.of(context).goBack();
              },
              child: Text("goBack", style: style),
            ),
          ],
        ),
      ),
    );
  }
}
