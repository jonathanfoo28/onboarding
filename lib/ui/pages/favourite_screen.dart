import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onboard/model/api/package_model.dart';
import 'package:onboard/ui/pages/details_screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/provider/favourite_provider.dart';
import 'package:onboard/viewmodel/shared_preferences/load_favourite.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => FavouritePageState();
}

class FavouritePageState extends State<FavouritePage> {
  List<Package> favouritePackages = [];

  @override
  void initState() {
    super.initState();
    loadFavourites(context);
  }

  @override
  Widget build(BuildContext context) {
    final favourtiteProvider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
        body: favourtiteProvider.favourtiePackage.isEmpty
            ? const Center(
                child: Text(
                'No Favourites !',
                style: TextStyle(fontSize: 16),
              ))
            : ListView.builder(
                itemCount: favourtiteProvider.favourtiePackage.length,
                itemBuilder: (context, index) {
                  final packageName =
                      favourtiteProvider.favourtiePackage[index];
                  return Dismissible(
                      onDismissed: (direction) {
                        favourtiteProvider.toggleFavourite(packageName);
                      },
                      key: Key(packageName),
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.heart_solid,
                          color: Colors.red,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(pname: packageName),
                            ),
                          );
                        },
                        title: Text(packageName),
                        trailing: const Icon(Icons.arrow_right),
                      ));
                }));
  }
}
