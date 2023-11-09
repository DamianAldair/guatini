import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/providers/appinfo_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).about),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          _background(),
          _content(context),
        ],
      ),
    );
  }

  Container _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color.fromARGB(0, 0, 0, 0),
            Color.fromARGB(200, 0, 0, 0),
          ],
        ),
      ),
    );
  }

  ListView _content(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        const SizedBox(height: 30.0),
        Center(
          child: Text(
            AppInfo().appName,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 30.0,
            ),
          ),
        ),
        Center(
          child: Text(
            '${AppLocalizations.of(context).version} ${AppInfo().version}',
            style: const TextStyle(
              color: Color.fromARGB(150, 255, 255, 255),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: size.width * 0.35,
            height: size.width * 0.35,
            child: Image.asset('assets/icons/android_icon.png'),
          ),
        ),
        Center(
          child: Text(
            AppInfo().copyright,
            style: const TextStyle(
              color: Color.fromARGB(150, 255, 255, 255),
            ),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Text(
              '${AppLocalizations.of(context).developedBy}: ${AppInfo().developer}',
              style: const TextStyle(
                color: Color.fromARGB(150, 255, 255, 255),
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.1,
          height: size.width * 0.15,
          child: Image.asset('assets/images/logo_cujae.png'),
        ),
        Text(
          '${AppInfo().getDepartment(context)}\n\n${AppInfo().getOrganization(context)}\n\n${AppInfo().organizationLite}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(150, 255, 255, 255),
          ),
        ),
        const SizedBox.square(dimension: 20.0),
      ],
    );
  }
}
