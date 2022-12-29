import 'package:dcli/dcli.dart';

void printHelp() {
  print('''
用法说明:
  创建页面
  > create:page UserDetail
  创建基于CupertinoPage的页面
  > create:page UserDetail -p
''');
}

// 用法: dua <command> [arguments]
// Run "dua help <command>" for more information about a command.
// Run "dua help -v" for verbose help output, including less commonly used options.
String tempConstants() {
  return '''
///Auto-Generate@Constants
''';
}

String tempPages() {
  return '''
///Auto-Generate@Pages

///
import './constants.dart';
import 'package:dua/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Auto-Generate:buildMaterialStackNavigationPage
DuaStackNavigationPage buildMaterialStackNavigationPage(String name, Widget page) {
  return DuaStackNavigationPage(name, MaterialPage(name: name, child: page));
}

///Auto-Generate:buildCupertinoStackNavigationPage
DuaStackNavigationPage buildCupertinoStackNavigationPage(String name, Widget page) {
  return DuaStackNavigationPage(name, CupertinoPage(name: name, child: page));
}

///Auto-Generate:NavigationPages
List<DuaStackNavigationPage> NavigationPages = <DuaStackNavigationPage>[
  ///Auto-Generate
];
''';
}

String page(String name, String lowername, String pageconstants) {
  return '''
import 'package:dua/navigation.dart';
import 'package:dua/widgets.dart';
import 'package:dua/structure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../_dua/constants.dart';
import './${lowername}_store.dart';

class ${name}Page extends StatefulWidget {
  const ${name}Page({super.key});

  @override
  State<StatefulWidget> createState() => _${name}Page();
}

class _${name}Page extends State<${name}Page> with DuaNavigationFocusMixin, DuaNavigationAutoReleaseMixin, DuaNavigationParamResultMixin, DuaNavigationBackHandlerMixin {
  @override
  String get name => $pageconstants;

  @override
  List makeAutoReleaseResource() {
    return [${name}Store()];
  }

  @override
  Future<bool> onBackHandlerInvoked() async {
    /// return true to prevent default action;
    return false;
  }

  @override
  void onFocusChanged(bool focused) {
    if (focused) {
      /// 如果有页面返回结果 @get-property routeResult
      /// debugPrint("\$routeResult");
    }
  }

  @override
  void initState() {
    loadNavigationFocus();
    loadNavigationBackHandler();
    loadNavigationAutoRelease();
    super.initState();

    /// 如果有页面跳转参数 @get-property routeParams
    /// debugPrint("\$routeParams");
  }

  @override
  void dispose() {
    super.dispose();
    disposeNavigationFocus();
    disposeNavigationBackHandler();
    disposeNavigationAutoRelease();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlainNavigationBar(
              title: $pageconstants,
              onPressBack: () {
                context.goBack();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(38.0),
              child: TextButton(
                onPressed: () {},
                child: const Text("Page $name", style: TextStyle(color: Colors.blue, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''';
}

String store(String name) {
  return '''
import 'package:dua/structure.dart';

class ${name}Store with Observable {
  ${name}Store() {
    makeAutoObservable();
  }

  late var count = 666.ov(i);

  late var text = "hello world - $name".ov(i);

  setText(String v) {
    text.value = v;
    update();
  }

  setCount(int v) {
    count.value = v;
    update();
  }
}
''';
}

class ConvertedName {
  String origin;
  List<String> segs;
  String uppercase;
  String lowercase;

  ConvertedName(this.origin, this.segs, this.uppercase, this.lowercase);
}

ConvertedName handleNameStr(String name) {
  var uppers = [];
  for (var i = 0; i < name.length; i++) {
    var unit = name.codeUnitAt(i);
    if (unit >= 65 && unit < 97) {
      uppers.add(i);
      continue;
    }
  }
  // UserProfileSetting
  var segs = <String>[];
  for (var i = 0; i < uppers.length; i++) {
    var start = uppers[i];
    var end = -1;
    if ((i + 1) >= uppers.length) {
      end = name.length;
    } else {
      end = uppers[i + 1];
    }
    segs.add(name.substring(start, end));
  }
  var upsegs = <String>[];
  var lwsegs = <String>[];
  for (var i = 0; i < segs.length; i++) {
    upsegs.add(segs[i].toUpperCase());
  }
  for (var i = 0; i < segs.length; i++) {
    lwsegs.add(segs[i].toLowerCase());
  }
  return ConvertedName(
    name,
    segs,
    upsegs.join('_'),
    lwsegs.join('_'),
  );
}
