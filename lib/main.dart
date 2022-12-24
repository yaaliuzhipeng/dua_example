import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }

  final _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) {
        debugPrint('首页 state.location => ${state.location}');
        return MaterialPage(
            child: MyPage(
          title: "首页",
        ));
      },
    ),
    GoRoute(
      path: '/a',
      name: 'a',
      pageBuilder: (context, state) {
        debugPrint('A页面 state.location => ${state.location}');
        return MaterialPage(
            child: MyPage(
          title: "A",
        ));
      },
    ),
  ]);
}

class MyPage extends StatelessWidget {
  MyPage({
    super.key,
    required this.title,
  });

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("I AM Page ${title}", style: const TextStyle(fontSize: 30))),
          A(title: title),
          B(title: title),
          TextButton(onPressed: () {}, child: Text('发送广播')),
          TextButton(onPressed: () {}, child: Text('改变 M')),
          TextButton(
              onPressed: () {
                GoRouter.of(context).pushNamed('a');
              },
              child: Text('前进')),
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: Text('返回'),
          ),
          C(title: title),
        ],
      ),
    );
  }
}

class A extends StatelessWidget {
  A({super.key, required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Text("${1}");
  }
}

class B extends StatelessWidget {
  B({super.key, required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Text("${1}");
  }
}

class C extends StatefulWidget {
  C({super.key, required this.title});

  String title;

  @override
  State<StatefulWidget> createState() => _C();
}

class _C extends State<C> {
  late void Function() unSubscribe;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    unSubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
