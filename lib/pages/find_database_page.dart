import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:external_path/external_path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/dialogs.dart';
import 'package:path/path.dart' as p;

class FindDatabasePage extends StatefulWidget {
  const FindDatabasePage({Key? key}) : super(key: key);

  @override
  State<FindDatabasePage> createState() => _FindDatabasePageState();
}

class _FindDatabasePageState extends State<FindDatabasePage> {
  final prefs = UserPreferences();
  String path = '';

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> content = [];
    try {
      content =
          Directory(path).listSync().where((e) => e is Directory || (e is File && DbProvider.canBeDb(e.path))).toList()
            ..sort((a, b) {
              final aIsDir = a is Directory;
              final bIsDir = b is Directory;
              if (aIsDir && !bIsDir) return -1;
              if (!aIsDir && bIsDir) return 1;
              return a.path.toLowerCase().compareTo(b.path.toLowerCase());
            });
    } catch (_) {
      path = '';
    }

    return WillPopScope(
      onWillPop: path.isEmpty
          ? () async => true
          : () async {
              final storages = await ExternalPath.getExternalStorageDirectories();
              if (storages.contains(path)) {
                path = '';
              } else {
                List<String> tree = p.split(path);
                tree.removeLast();
                path = p.joinAll(tree);
                if (path[0] != '/') path = '/$path';
              }
              setState(() {});
              return false;
            },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: AppLocalizations.of(context).closeExplorer,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppLocalizations.of(context).findDatabase),
          centerTitle: true,
          actions: [
            if (path.isNotEmpty)
              IconButton(
                tooltip: AppLocalizations.of(context).levelUp,
                icon: const Icon(Icons.drive_folder_upload_outlined),
                onPressed: () => Navigator.maybePop(context),
              ),
          ],
          bottom: path.isEmpty
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(40.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    child: Scrollbar(
                      thickness: 1.5,
                      radius: const Radius.circular(10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final f in p.split(path)..removeWhere((e) => e == '/' || e == '\\'))
                              Row(
                                children: [
                                  Text(f),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: IconTheme.of(context).color?.withOpacity(0.5),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        body: path.isEmpty
            ? FutureBuilder(
                future: ExternalPath.getExternalStorageDirectories(),
                builder: (_, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(AppLocalizations.of(context).errorObtainingInfo),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final storages = snapshot.data!;
                  return ListView.builder(
                    itemCount: storages.length,
                    itemBuilder: (_, int i) {
                      final storage = storages[i];
                      return ListTile(
                        leading: CircleAvatar(child: icon(storage)),
                        title: Text(storageName(context, storage)),
                        subtitle: Text(storage),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => setState(() => path = storage),
                      );
                    },
                  );
                },
              )
            : content.isEmpty
                ? const EmptyFolderPlaceholder()
                : Scrollbar(
                    radius: const Radius.circular(10.0),
                    child: ListView.builder(
                      itemCount: content.length,
                      itemBuilder: (_, int i) {
                        final isDir = content[i] is Directory;
                        final dir = isDir ? content[i] as Directory : null;
                        final file = !isDir ? content[i] as File : null;
                        final isAdded = file != null && prefs.databasesNotifier.value.contains(file.path);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isDir ? Colors.transparent : null,
                            child: isDir ? const Icon(Icons.folder_rounded) : const FaIcon(FontAwesomeIcons.database),
                          ),
                          title: Text(p.basename(content[i].path)),
                          trailing: isDir
                              ? const Icon(Icons.chevron_right_rounded)
                              : isAdded
                                  ? Text(AppLocalizations.of(context).added)
                                  : null,
                          onTap: isDir
                              ? () => setState(() => path = dir!.path)
                              : () {
                                  if (isAdded) {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context).alreadyAdded),
                                      ),
                                    );
                                  } else {
                                    DbProvider.check(file!.path).then((bool? correct) {
                                      if (correct == null) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => infoDialog(
                                            context,
                                            Text(AppLocalizations.of(context).errorAnalyzingDb),
                                          ),
                                        );
                                      } else if (!correct) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => infoDialog(
                                            context,
                                            Text(AppLocalizations.of(context).dbStructureNoCorrect),
                                          ),
                                        );
                                      } else {
                                        setState(() => prefs.newDatabase(file.path));
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(AppLocalizations.of(context).addedDatabase),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Icon icon(String path) {
    if (path == '/storage/emulated/0') {
      return const Icon(Icons.phone_android_rounded);
    }
    if (path.startsWith('/storage/') && path.split('/').length == 3) {
      return const Icon(Icons.sd_card_rounded);
    }
    return const Icon(Icons.folder_rounded);
  }

  String storageName(BuildContext context, String storage) {
    if (storage == '/storage/emulated/0') {
      return AppLocalizations.of(context).internalStorage;
    }
    if (storage.startsWith('/storage/') && storage.split('/').length == 3) {
      return AppLocalizations.of(context).sdCard;
    }
    return '';
  }
}

class EmptyFolderPlaceholder extends StatelessWidget {
  const EmptyFolderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    const space = 20.0;
    final color = Colors.grey.withOpacity(0.5);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(space),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: MediaQuery.of(context).size.width / 5,
              color: color,
            ),
            const SizedBox(height: space),
            Text(
              AppLocalizations.of(context).noElements,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
