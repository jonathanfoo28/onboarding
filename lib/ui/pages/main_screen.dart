import 'package:flutter/material.dart';
import 'package:onboard/generated/generated/l10n/l10n.dart';
import 'package:onboard/model/enum/flavor_enum.dart';
import 'package:onboard/ui/pages/favourite_screen.dart';
import 'package:onboard/ui/theme/icon_create.dart';
import 'package:onboard/ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onboard/ui/pages/setting_screen.dart';
import 'package:onboard/ui/pages/search_screen.dart';
import 'package:onboard/viewmodel/provider/appstate_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.flavor});
  final Flavor flavor;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  final List<Widget?> pages = [null, null, null];
  final List<String> pageTitle = [
    'Welcome to Pub.dev',
    'Favourite',
    'Settings'
  ];

  void onPageSelected(int index) {
    setState(() {
      selectedIndex = index;
      if (pages[index] == null) {
        pages[index] = getPageWidget(index);
      }
    });
  }

  Widget getPageWidget(int index) {
    switch (index) {
      case 0:
        return const SearchPage();
      case 1:
        return const FavouritePage();
      case 2:
        return const SettingPage();
      default:
        return const SearchPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppProvider>(context);
    ThemeData theme;

    switch (widget.flavor) {
      case Flavor.staging:
        theme = AppThemes.stagingTheme;
        break;
      case Flavor.production:
        theme = AppThemes.productionTheme;
        break;
      case Flavor.development:
        theme = AppThemes.developmentTheme;
    }

    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      title: 'main',
      theme: theme,
      home: Builder(builder: (context) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: Text(pageTitle[selectedIndex]),
            backgroundColor: theme.appBarTheme.backgroundColor,
          ),
          body: pages[selectedIndex],
          bottomNavigationBar: BottomAppBar(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: iconCreate(
                    name: 'Search',
                    icon: Icons.search,
                    isSelected: appState.isSearchSelected,
                    onPressed: () {
                      onPageSelected(0);
                      setState(() {
                        appState.toggleSearch();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: iconCreate(
                      icon: Icons.favorite,
                      name: 'Favourites',
                      isSelected: appState.isFavouriteSelected,
                      onPressed: () {
                        onPageSelected(1);
                        setState(() {
                          appState.toggleFavourite();
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: iconCreate(
                      icon: Icons.settings,
                      name: 'Settings',
                      isSelected: appState.isSetttingsSelected,
                      onPressed: () {
                        onPageSelected(2);
                        setState(() {
                          appState.toggleSettings();
                        });
                      }),
                ),
              ],
            ),
          ),
        ));
      }),
    );
  }
}
