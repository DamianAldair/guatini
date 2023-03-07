import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/pages/simple_search_page.dart';
import 'package:guatini/widgets/dialogs.dart';
import 'package:guatini/widgets/drawer_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (_) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).home),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: AppLocalizations.of(context).search,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SimpleSearch(context),
                );
              },
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: const Center(child: Text('This is the main page')),
      ),
    );
  }
}
