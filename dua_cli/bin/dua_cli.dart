import 'package:dua_cli/dua_cli.dart' as dua_cli;
import 'package:dcli/dcli.dart';

void main(List<String> arguments) {
  var pubspec = find('pubspec.yaml', workingDirectory: pwd, recursive: false);
  if (pubspec.toList().isEmpty) {
    printerr("please execute commands inside a flutter project");
    return;
  }

  var parser = ArgParser();
  parser.addCommand(
    'create:page',
  );
  try {
    var results = parser.parse(arguments);
    var pageName = results.arguments[1];
    bool useCupertino = results.arguments.indexWhere((element) => element.contains("-p")) != -1;

    if (pageName.startsWith(RegExp(r'[a-z]'))) {
      printerr("页面名应该大写字母开头、例如: UserDetail ");
      return;
    }
    var cname = dua_cli.handleNameStr(pageName);

    var libGenDua = join(pwd, "lib/pages/_dua");
    var constantsGenFile = join(libGenDua, "constants.dart");
    var pagesGenFile = join(libGenDua, "pages.dart");

    var c1 = [];
    List<String> c2 = [];
    if (!exists(libGenDua)) {
      createDir(libGenDua, recursive: true);
    }
    if (!exists(constantsGenFile)) {
      touch(constantsGenFile, create: true);
      constantsGenFile.write(dua_cli.tempConstants());
    }
    c1 = read(constantsGenFile).toList();
    if (!exists(pagesGenFile)) {
      touch(pagesGenFile, create: true);
      pagesGenFile.write(dua_cli.tempPages());
    }
    c2 = read(pagesGenFile).toList();

    // PAGE_USER_DETAIL
    String PAGE_NAME = "PAGE_${cname.uppercase}";

    // 第一步、写文件
    var pageDir = join(pwd, "lib/pages/${cname.lowercase}");
    if (!exists(pageDir)) {
      createDir(pageDir, recursive: true);
    }
    var pageFile = join(pageDir, "${cname.lowercase}_page.dart");
    var storeFile = join(pageDir, "${cname.lowercase}_store.dart");
    if (!exists(pageFile)) {
      touch(pageFile, create: true);
    }
    if (!exists(storeFile)) {
      touch(storeFile, create: true);
    }
    pageFile.write(dua_cli.page(cname.origin, cname.lowercase, PAGE_NAME));
    storeFile.write(dua_cli.store(cname.origin));

    // 第二步、写PAGE常量
    var newContent = "const $PAGE_NAME = \"${cname.origin}\";";
    c1.add(newContent);
    constantsGenFile.write(c1.join('\n'));

    // 第三步、写路由
    String pagetype = useCupertino ? "buildCupertinoStackNavigationPage" : "buildMaterialStackNavigationPage";
    newContent = "\t$pagetype($PAGE_NAME, const ${cname.origin}Page()),";

    var ind = c2.lastIndexWhere((String element) => element.contains("Auto-Generate"));
    c2.insert(ind + 1, newContent);
    c2.insert(ind + 2, "");
    c2.insert(ind + 3, "\t///Auto-Generate");
    c2.insert(1, "import '../${cname.lowercase}/${cname.lowercase}_page.dart';");
    pagesGenFile.write(c2.join('\n'));

    print('🎉done');
  } catch (e) {
    dua_cli.printHelp();
  }
}
