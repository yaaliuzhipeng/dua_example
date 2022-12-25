import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dua_example/dua/lib/navigation.dart';

class UserDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserDetail();
}

class _UserDetail extends State<UserDetail> {
  final style = const TextStyle(fontSize: 18, color: Colors.blue);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
              Text("Page UserDetail"),
              TextButton(
                onPressed: () {
                  DuaStackNavigationDelegate.of(context).goBack(name: "/");
                },
                child: Text("goBack home", style: style),
              ),
              TextButton(
                onPressed: () {
                  DuaStackNavigationDelegate.of(context).goBack(result: "success");
                },
                child: Text("goBack with result", style: style),
              ),
              TextButton(
                onPressed: () {
                  DuaStackNavigationDelegate.of(context).goBack();
                },
                child: Text("goBack", style: style),
              ),
              TextButton(
                onPressed: () {
                  DuaStackNavigationDelegate.of(context).reset((currentRoutes) {
                    var routes = currentRoutes.sublist(0, 1);
                    return routes;
                  });
                },
                child: Text("reset", style: style),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
