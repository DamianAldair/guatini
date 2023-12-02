import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/databases_page.dart';
import 'package:guatini/pages/simple_search_page.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/providers/ads_provider.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/permissions_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/dialogs.dart';
import 'package:guatini/widgets/drawer_widget.dart';
import 'package:sqflite/sqflite.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SwiperController controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    AdsProvider.context = context;
    final prefs = UserPreferences();
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
            ValueListenableBuilder(
              valueListenable: prefs.dbPathNotifier,
              builder: (_, path, ___) {
                if (path == null) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.search_rounded),
                  tooltip: AppLocalizations.of(context).search,
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SimpleSearch(context),
                    );
                  },
                );
              },
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: ValueListenableBuilder(
            valueListenable: prefs.dbPathNotifier,
            builder: (_, __, ___) {
              final error = Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  AppLocalizations.of(context).errorObtainingInfo,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              );
              const loading = Center(child: CircularProgressIndicator());
              final noDb = Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.database,
                      color: Colors.grey.withOpacity(0.5),
                      size: MediaQuery.of(context).size.width / 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        AppLocalizations.of(context).noSelectedDatabase,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context).findDatabase),
                      onPressed: () {
                        PermissionsHandler.requestStoragePermission(
                          context,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DatabasesPage()),
                            );
                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                            prefs.dbPathNotifier.notifyListeners();
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
              return FutureBuilder(
                future: DbProvider.database,
                builder: (_, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) return noDb;
                  if (!snapshot.hasData) return loading;
                  final db = snapshot.data as Database;
                  return FutureBuilder(
                    future: SearchProvider.homeSuggestion(db, prefs.suggestions),
                    builder: (_, AsyncSnapshot<List<SpeciesModel>> snapshot) {
                      if (snapshot.hasError) return error;
                      if (!snapshot.hasData) return loading;
                      final list = snapshot.data!;
                      if (list.isNotEmpty) {
                        return Swiper(
                          loop: false,
                          autoplay: true,
                          autoplayDisableOnInteraction: true,
                          autoplayDelay: 5000,
                          duration: 1000,
                          viewportFraction: 0.85,
                          outer: true,
                          indicatorLayout: PageIndicatorLayout.SCALE,
                          controller: controller,
                          pagination: const SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                              color: Color.fromARGB(255, 200, 200, 200),
                              size: 7.0,
                              activeSize: 7.0,
                            ),
                          ),
                          itemCount: list.length,
                          itemBuilder: (_, int i) => _suggestionCard(context, list[i]),
                          onTap: (i) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SpeciesDetailsPage(list[i].id),
                            ),
                          ),
                        );
                      }
                      return FutureBuilder(
                        future: SearchProvider.homeSuggestionWithoutImages(db, prefs.suggestions),
                        builder: (_, AsyncSnapshot<List<SpeciesModel>> snapshot) {
                          if (snapshot.hasError) return error;
                          if (!snapshot.hasData) return loading;
                          final list = snapshot.data!;
                          if (list.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  AppLocalizations.of(context).noElements,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return Swiper(
                            loop: false,
                            autoplay: true,
                            autoplayDisableOnInteraction: true,
                            autoplayDelay: 5000,
                            duration: 1000,
                            viewportFraction: 0.85,
                            outer: true,
                            indicatorLayout: PageIndicatorLayout.SCALE,
                            controller: controller,
                            pagination: const SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                color: Color.fromARGB(255, 200, 200, 200),
                                size: 7.0,
                                activeSize: 7.0,
                              ),
                            ),
                            itemCount: list.length,
                            itemBuilder: (_, int i) => _suggestionCard(context, list[i]),
                            onTap: (i) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SpeciesDetailsPage(list[i].id),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            }),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: prefs.dbPathNotifier,
          builder: (_, String? path, ___) {
            if (path == null) return const SizedBox.shrink();
            return FloatingActionButton(
              tooltip: AppLocalizations.of(context).refresh,
              child: const Icon(Icons.refresh_rounded),
              onPressed: () {
                setState(() {});
                controller.move(0);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _suggestionCard(BuildContext context, SpeciesModel species) {
    const radius = 25.0;
    final isDark = AdaptiveTheme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
        left: 10.0,
        right: 10.0,
        bottom: 30.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: isDark ? const Color.fromARGB(255, 50, 50, 50) : const Color.fromARGB(255, 220, 220, 220),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(65, 0, 0, 0),
            offset: Offset(0.0, 5.0),
            blurRadius: 3.0,
          )
        ],
      ),
      child: OrientationBuilder(
        builder: (_, Orientation orientation) {
          final portrait = orientation == Orientation.portrait;
          final children = [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          species.image,
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: isDark ? Colors.black.withOpacity(0.6) : Colors.grey.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: species.id.toString(),
                      child: species.image,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(25.0),
              width: portrait ? null : MediaQuery.of(context).size.width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    species.searchName ?? species.scientificName ?? '',
                    overflow: portrait ? TextOverflow.ellipsis : null,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    species.searchName != null ? species.scientificName ?? '' : '',
                    overflow: portrait ? TextOverflow.ellipsis : null,
                  ),
                ],
              ),
            ),
          ];

          return portrait
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                );
        },
      ),
    );
  }
}
