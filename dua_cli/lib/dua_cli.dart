import 'package:dcli/dcli.dart';

void printHelp() {
  print('''
Accelerate your app development with dua cli.

Common commands:
  dua init

Usage: dua <command> [arguments]

Available commands:

  init              Config project,install libs and set default configs
  create            Create template file like page,store etc...
    1. create page with page-scoped statemanager
    dua create:page --name <page name> --path <page path> --store <store name default to page name with Store suffix>

    2. create simple statemanager template
    dua create:state --name

Run "dua help <command>" for more information about a command.
Run "dua help -v" for verbose help output, including less commonly used options.
''');
}
