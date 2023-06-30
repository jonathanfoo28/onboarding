import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onboard/viewmodel/provider/favourite_provider.dart';
import 'package:onboard/viewmodel/provider/appstate_provider.dart';
import 'model/enum/flavor_enum.dart';
import 'package:onboard/ui/pages/main_screen.dart';

void main() {
  const Flavor flavor = Flavor.staging;

  // ignore: non_constant_identifier_names
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppProvider()),
      ChangeNotifierProvider(create: ((context) => FavouriteProvider())),
    ],
    child: const MainPage(flavor: flavor),
  ));
}
