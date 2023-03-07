import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/pages/find_database_pege.dart';
import 'package:guatini/providers/permissions_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/delete_db_dialogs.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabasesPage extends StatefulWidget {
  const DatabasesPage({Key? key}) : super(key: key);

  @override
  State<DatabasesPage> createState() => _DatabasesPageState();
}

class _DatabasesPageState extends State<DatabasesPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final currentDb = prefs.dbPath;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).database),
      ),
      body: StreamBuilder(
        stream: prefs.databasesStream,
        builder: (_, AsyncSnapshot<List<String>> snapshot) {
          List<String> databases;
          if (!snapshot.hasData) {
            databases = prefs.databases;
          } else {
            databases = snapshot.data!;
          }
          databases.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
          return databases.isEmpty
              ? Center(child: Text(AppLocalizations.of(context).noDatabases))
              : ListView.builder(
                  itemCount: databases.length,
                  itemBuilder: (_, int i) {
                    final db = databases[i];
                    return ListTile(
                      leading: db == currentDb
                          ? const Icon(Icons.radio_button_checked_rounded)
                          : const Icon(Icons.radio_button_off_rounded),
                      title: Text(db),
                      trailing: PopupMenuButton(
                        itemBuilder: (_) {
                          void deleteDb() {
                            if (db == currentDb) {
                              prefs.dbPath = '';
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
                                  Text(AppLocalizations.of(context)
                                      .deleteFromList),
                                ],
                              ),
                              onTap: () => Future.delayed(
                                Duration.zero,
                                () => showDialog(
                                  context: context,
                                  builder: (_) => deleteDatabaseDialog(
                                    context: context,
                                    permanently: false,
                                    function: () => setState(() => deleteDb()),
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
                                  Text(AppLocalizations.of(context)
                                      .deletePermanently),
                                ],
                              ),
                              onTap: () => Future.delayed(
                                Duration.zero,
                                () => showDialog(
                                  context: context,
                                  builder: (_) => deleteDatabaseDialog(
                                    context: context,
                                    permanently: true,
                                    function: () => setState(() {
                                      deleteDb();
                                      final dir = Directory(db);
                                      dir.deleteSync(recursive: true);
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(context)
                                                .deletedDatabase,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                      onTap: () => setState(() => prefs.dbPath = db),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
    );
  }
}
