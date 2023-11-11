import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/pages/home_page.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  final Widget? home;

  const OnboardingScreen({
    Key? key,
    this.home,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isLastPage = false;
  final buttomBarHeight = 60.0;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();

    if (widget.home != null && !prefs.firstTime) return widget.home!;

    const duration = Duration(milliseconds: 500);
    const curve = Curves.easeIn;

    final pages = <Widget>[
      _Page(
        assetImagePath: 'assets/icons/android_icon.png',
        color: const Color.fromARGB(255, 122, 195, 255),
        title: AppLocalizations.of(context).guatini,
        subtitle: AppLocalizations.of(context).guatiniExp,
      ),
      _Page(
        assetImagePath: 'assets/images/encyclopedia.png',
        color: const Color.fromARGB(255, 255, 190, 136),
        title: AppLocalizations.of(context).encyclopedia,
        subtitle: AppLocalizations.of(context).encyclopediaExp,
      ),
      _Page(
        assetImagePath: 'assets/images/environment.png',
        color: const Color.fromARGB(255, 183, 235, 125),
        title: AppLocalizations.of(context).environment,
        subtitle: AppLocalizations.of(context).environmentExp,
      ),
      _Page(title: '${AppLocalizations.of(context).go}...'),
    ];
    final lastPage = pages.length - 1;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: buttomBarHeight),
        child: PageView(
          controller: controller,
          onPageChanged: (i) => setState(() => isLastPage = i == lastPage),
          children: pages,
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: buttomBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: Text(AppLocalizations.of(context).skip),
              onPressed: () => controller.animateToPage(
                lastPage,
                duration: duration,
                curve: curve,
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: WormEffect(
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                  spacing: 16,
                  activeDotColor: AdaptiveTheme.of(context).theme.primaryColor,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: duration,
                  curve: curve,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (!isLastPage) {
                  controller.nextPage(
                    duration: duration,
                    curve: curve,
                  );
                } else if (widget.home == null) {
                  Navigator.pop(context);
                } else {
                  prefs.firstTime = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainPage()),
                  );
                }
              },
              child: Text(AppLocalizations.of(context).next),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final String? assetImagePath;
  final Color? color;
  final String title;
  final String? subtitle;

  const _Page({
    Key? key,
    this.assetImagePath,
    this.color,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;
    final flex0 = assetImagePath == null && subtitle == null;

    return Container(
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: padding * 2),
          if (assetImagePath != null)
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width / 4,
                  vertical: padding * 2,
                ),
                child: Image.asset(assetImagePath!),
              ),
            ),
          Expanded(
            flex: flex0 ? 0 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: flex0 ? 35.0 : 25.0),
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
