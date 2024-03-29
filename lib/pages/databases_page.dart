import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/pages/find_database_page.dart';
import 'package:guatini/pages/home_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/permissions_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/dialogs.dart';

class DatabasesPage extends StatefulWidget {
  const DatabasesPage({Key? key}) : super(key: key);

  @override
  State<DatabasesPage> createState() => _DatabasesPageState();
}

class _DatabasesPageState extends State<DatabasesPage> {
  final prefs = UserPreferences();
  bool needRefresh = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!needRefresh) return true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).database),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              tooltip: AppLocalizations.of(context).info,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => infoDialog(
                    context,
                    Text(AppLocalizations.of(context).databaseSelectedInfo),
                  ),
                );
              },
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: prefs.databasesNotifier,
          builder: (_, List<String> list, ___) {
            final databases = list..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
            return databases.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context).noDatabases),
                        Text(AppLocalizations.of(context).addOneDatabase),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: databases.length,
                    itemBuilder: (_, int i) {
                      final db = databases[i];
                      return ListTile(
                        leading: db == prefs.dbPathNotifier.value
                            ? const Icon(Icons.radio_button_checked_rounded)
                            : const Icon(Icons.radio_button_off_rounded),
                        title: Text(db),
                        trailing: PopupMenuButton(
                          itemBuilder: (_) {
                            void deleteDb() {
                              if (db == prefs.dbPathNotifier.value) {
                                DbProvider.close();
                              }
                              prefs.deleteDatabase(db);
                            }

                            return [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.close_rounded),
                                    ),
                                    Text(AppLocalizations.of(context).deleteFromList),
                                  ],
                                ),
                                onTap: () => Future.delayed(
                                  Duration.zero,
                                  () => showDialog(
                                    context: context,
                                    builder: (_) => deleteDatabaseDialog(
                                      context: context,
                                      permanently: false,
                                      function1: () => setState(() {
                                        deleteDb();
                                        needRefresh = true;
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.delete_forever_rounded),
                                    ),
                                    Text(AppLocalizations.of(context).deletePermanently),
                                  ],
                                ),
                                onTap: () => Future.delayed(
                                  Duration.zero,
                                  () => showDialog(
                                    context: context,
                                    builder: (_) => deleteDatabaseDialog(
                                      context: context,
                                      permanently: true,
                                      function1: () => setState(() {
                                        deleteDb();
                                        needRefresh = true;
                                        final file = File(db);
                                        file.delete().then((_) {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppLocalizations.of(context).deletedDatabase,
                                              ),
                                            ),
                                          );
                                        });
                                      }),
                                      function2: () => setState(() {
                                        deleteDb();
                                        final dir = File(db).parent;
                                        dir.delete(recursive: true).then((_) {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppLocalizations.of(context).deletedDataSource,
                                              ),
                                            ),
                                          );
                                        });
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ];
                          },
                        ),
                        onTap: () {
                          if (prefs.dbPathNotifier.value != db) {
                            File(db).exists().then((exists) {
                              if (exists) {
                                DbProvider.open(db).then((_) => setState(() => needRefresh = true));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => dbNotFoundDialog(context: context),
                                );
                              }
                            });
                          }
                        },
                      );
                    },
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            PermissionsHandler.requestStoragePermission(
              context,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FindDatabasePage()),
                );
              },
            );
          },
          tooltip: AppLocalizations.of(context).addDatabase,
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
