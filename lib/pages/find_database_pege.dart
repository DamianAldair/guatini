import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:external_path/external_path.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class FindDatabasePage extends StatefulWidget {
  const FindDatabasePage({Key? key}) : super(key: key);

  @override
  State<FindDatabasePage> createState() => _FindDatabasePageState();
}

class _FindDatabasePageState extends State<FindDatabasePage> {
  String path = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: path.isEmpty
          ? () async => true
          : () async {
              final storages =
                  await ExternalPath.getExternalStorageDirectories();
              if (storages.contains(path)) {
                path = '';
              } else {
                List<String> tree = path.split('/');
                tree.removeLast();
                path = p.joinAll(tree);
                if (path[0] != '/') path = '/$path';
              }
              setState(() {});
              return false;
            },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).findDatabase),
        ),
        body: path.isEmpty
            ? FutureBuilder(
                future: ExternalPath.getExternalStorageDirectories(),
                builder: (_, AsyncSnapshot<List<String>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final storages = snapshot.data!;
                  return ListView.builder(
                    itemCount: storages.length,
                    itemBuilder: (_, int i) {
                      final storage = storages[i];
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.sd_card_rounded),
                        ),
                        title: Text(storage),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => setState(() => path = storage),
                      );
                    },
                  );
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: Directory(path).listSync().length,
                itemBuilder: (_, int i) {
                  List<FileSystemEntity> content = Directory(path).listSync();
                  content.sort((a, b) =>
                      a.path.toLowerCase().compareTo(b.path.toLowerCase()));
                  final dir = content[i];
                  if (dir is File) return Container();
                  final isDB = File(
                    p.join(dir.path, DbProvider.relativeDbPath),
                  ).existsSync();
                  final isAdded =
                      UserPreferences().databases.contains(dir.path);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: !isDB ? Colors.transparent : null,
                      child: isDB
                          ? const Icon(Icons.menu_book_rounded)
                          : const Icon(Icons.folder_rounded),
                    ),
                    title: Text(dir.path.split('/').last),
                    trailing: !isDB
                        ? const Icon(Icons.chevron_right_rounded)
                        : isAdded
                            ? Text(AppLocalizations.of(context).added)
                            : null,
                    onTap: !isDB
                        ? () => setState(() => path = dir.path)
                        : () {
                            if (isAdded) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .alreadyAdded),
                                ),
                              );
                            } else {
                              setState(() {
                                UserPreferences().newDatabase(dir.path);
                              });
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      AppLocalizations.of(context).addDatabase),
                                ),
                              );
                            }
                          },
                  );
                },
              ),
      ),
    );
  }
}
