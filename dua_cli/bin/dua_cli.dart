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
    'init',
    ArgParser()
      ..addFlag('pageLocation', abbr: 'p')
      ..addFlag('path', abbr: 'p'),
  );
  parser.addCommand(
    'create:page',
    ArgParser()
      ..addFlag('name', abbr: 'n')
      ..addFlag('path', abbr: 'p'),
  );

  try {
    var results = parser.parse(arguments);
    print("command: ${results.command}    arguments: ${results.arguments}");
  } catch (e) {
    print("命令使用出错");
  }
}
