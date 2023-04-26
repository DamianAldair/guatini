import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/simple_search_page.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/providers/db_provider.dart';
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
        body: FutureBuilder(
          future: DbProvider.database,
          builder: (_, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              Future.delayed(const Duration(seconds: 3));
              return const Center(child: CircularProgressIndicator());
            }
            final db = snapshot.data as Database;
            final max = UserPreferences().suggestions;
            return FutureBuilder(
              future: SearchProvider.homeSuggestion(db, max),
              builder: (_, AsyncSnapshot<List<SpeciesModel>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snapshot.data!;
                if (list.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context).noDatabases),
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
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: AppLocalizations.of(context).refresh,
          child: const Icon(Icons.refresh_rounded),
          onPressed: () {
            setState(() {});
            controller.move(0);
          },
        ),
      ),
    );
  }

  Widget _suggestionCard(BuildContext context, SpeciesModel species) {
    const radius = 25.0;
    final isDark = AdaptiveTheme.of(context).mode.isDark;
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
        left: 10.0,
        right: 10.0,
        bottom: 30.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: isDark
            ? const Color.fromARGB(255, 50, 50, 50)
            : const Color.fromARGB(255, 220, 220, 220),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(65, 0, 0, 0),
            offset: Offset(0.0, 5.0),
            blurRadius: 3.0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                            color: isDark
                                ? const Color.fromARGB(150, 0, 0, 0)
                                : const Color.fromARGB(150, 255, 255, 255),
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
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  species.searchName!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  species.scientificName!,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
