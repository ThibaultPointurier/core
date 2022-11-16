import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/console.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:path/path.dart';

class MakeModule extends MineralCliCommand {
  @override
  String name = 'make:module';

  @override
  String description = 'Make a new module structure';

  @override
  Future<void> handle (ArgResults args) async {
    if (args.arguments.length == 1) {
      Console.error(message: 'The name argument is not defined');
      return;
    }

    String filename = args.arguments.elementAt(1).capitalCase;

    final useExistLocation = Confirm(
      prompt: 'Do you want to use an existing location on your disk ?',
      defaultValue: true,
    ).interact();

    late File file;
    late Directory directory;

    if (useExistLocation) {
      List<Directory> directories = await getDirectories();

      final location = Console.cli.choice(
        label: 'Where do you want to place your file ?',
        list: directories,
        items: directories.map((directory) => directory.path
          .replaceAll(join(Directory.current.path, 'src'), 'App')
          .replaceAll('\\', '/'))
          .toList()
      );

      directory = Directory(join(location.path, filename.snakeCase));
      file = File(join(directory.path, '${filename.snakeCase}.dart'));
    } else {
      final location = Input(
        prompt: 'Target folder location',
        defaultValue: 'App/folder',
      ).interact();

      directory = Directory(join(Directory.current.path, 'src', location.replaceAll('App/', '').replaceAll('App', ''), filename.snakeCase));
      file = File(join(directory.path, '${filename.snakeCase}.dart'));
    }

    await Directory(join(directory.path, 'events')).create(recursive: true);
    await Directory(join(directory.path, 'commands')).create(recursive: true);
    await Directory(join(directory.path, 'stores')).create(recursive: true);

    await file.create(recursive: true);
    await writeFileContent(file, getTemplate(filename));

    Console.cli.success(message: 'File created ${file.uri}');
  }

  String getTemplate (String filename) => '''
import 'package:mineral/core.dart';

class ${filename.pascalCase} extends MineralModule {
  ${filename.pascalCase} (): super('${filename.snakeCase}', '${filename.capitalCase}', '${filename.capitalCase} description');
  @override
  Future<void> init () async {
    commands.register([]);
    events.register([]);
    contextMenus.register([]);
    states.register([]);
  }
}
  ''';
}
