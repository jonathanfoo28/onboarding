import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onboard/ui/pages/details_screen.dart';
import 'package:onboard/model/api/package_model.dart';
import 'package:onboard/viewmodel/provider/favourite_provider.dart';
import 'dart:convert';
import 'package:onboard/model/enum/sortkey_enum.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Package> packages = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isFetching = false;
  bool haveData = true;
  bool isCheckboxVisible = false;
  SortKey? selectedSortOption;
  void handleCheckboxTap(SortKey? option) {
    selectedSortOption = option;
  }

  void showCheckboxDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyWidget(
          onChanged: handleCheckboxTap,
          onClosePressed: () {
            Navigator.of(context).pop();
            currentPage = 1;
            packages.clear();
            fetchPackages(searchController.text);
          },
        );
      },
    );
  }

  TextEditingController searchController = TextEditingController();

  void fetchPackages(String searchTerm) async {
    if (isFetching || !haveData) {
      return;
    }
    setState(() {
      isLoading = true;
      isFetching = true;
    });

    String sort = '';
    if (selectedSortOption == SortKey.searchrelevance) {
      sort = '';
    } else if (selectedSortOption == SortKey.mostlikes) {
      sort = 'like';
    } else if (selectedSortOption == SortKey.mostpubpoints) {
      sort = 'points';
    } else if (selectedSortOption == SortKey.newestpackage) {
      sort = 'top';
    } else if (selectedSortOption == SortKey.popularity) {
      sort = 'popularity';
    } else if (selectedSortOption == SortKey.recentlyupdated) {
      sort = 'updated';
    }

    String url =
        'http://pub.dev/api/search?q=$searchTerm&sort=$sort&page=$currentPage';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      List<dynamic> packagesJson = jsonData['packages'];

      setState(() {
        packages.addAll(
            packagesJson.map((json) => Package.fromJson(json)).toList());
        isLoading = false;
        isFetching = false;
        currentPage++;
      });
    } else {
      // ignore: avoid_print
      print(
          'Failed to fetch data from the API. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              children: [
                TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search For a Package...',
                      border: const OutlineInputBorder(),
                      suffixIcon: InkWell(
                        onTap: () => showCheckboxDialog(context),
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    onEditingComplete: () {
                      currentPage = 1;
                      packages.clear();
                      fetchPackages(searchController.text);
                    }),
                Expanded(
                  child: NotificationListener(
                    onNotification: (ScrollNotification notification) {
                      if (!isFetching &&
                          haveData &&
                          notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent) {
                        // Bottom reached, fetch more data
                        fetchPackages(searchController.text);
                      }
                      return false;
                    },
                    child: Builder(
                      builder: (context) {
                        if (packages.isEmpty && !isLoading) {
                          return const Center(child: Text('No Data :('));
                        } else {
                          // final packageFavourite = context.watch<AppProv>();
                          return ListView.builder(
                              itemCount: packages.length,
                              itemBuilder: (context, index) {
                                final favouriteProvider =
                                    Provider.of<FavouriteProvider>(context);
                                final isFavourited = favouriteProvider
                                    .isPackageFavorited(packages[index].name);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                            pname: packages[index].name),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      isFavourited
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color: isFavourited ? Colors.red : null,
                                    ),
                                    title: Text(packages[index].name),
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: null,
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget(
      {super.key,
      this.selectedSortOption,
      this.onChanged,
      required this.onClosePressed});

  final SortKey? selectedSortOption;
  final void Function(SortKey?)? onChanged;
  final VoidCallback onClosePressed;
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  SortKey? selectedSortOption;

  @override
  void initState() {
    super.initState();
    selectedSortOption = widget.selectedSortOption;
  }

  void handleCheckboxTap(SortKey? option, BuildContext context) {
    if (selectedSortOption == option) {
      return;
    }
    setState(() {
      selectedSortOption = option;
      widget.onChanged?.call(option);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sort By'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<SortKey>(
            title: const Text('Search Relevance'),
            value: SortKey.searchrelevance,
            onChanged: (SortKey? value) {
              handleCheckboxTap(value, context);
            },
            groupValue: selectedSortOption,
            selected: selectedSortOption == SortKey.searchrelevance,
            activeColor: Colors.blue,
          ),
          RadioListTile<SortKey>(
            title: const Text('Newest Package'),
            value: SortKey.newestpackage,
            onChanged: (SortKey? value) {
              setState(() {
                selectedSortOption = value;
              });
            },
            groupValue: selectedSortOption,
            selected: selectedSortOption == SortKey.newestpackage,
            activeColor: Colors.blue,
          ),
          RadioListTile<SortKey>(
            title: const Text('Recently Updated'),
            value: SortKey.recentlyupdated,
            onChanged: (SortKey? value) {
              handleCheckboxTap(value, context);
            },
            groupValue: selectedSortOption,
            selected: selectedSortOption == SortKey.recentlyupdated,
          ),
          RadioListTile<SortKey>(
            title: const Text('Popularity'),
            value: SortKey.popularity,
            onChanged: (SortKey? value) {
              handleCheckboxTap(value, context);
            },
            groupValue: selectedSortOption,
            selected: selectedSortOption == SortKey.popularity,
          ),
          RadioListTile(
            title: const Text('Most Likes'),
            value: SortKey.mostlikes,
            onChanged: (SortKey? value) {
              handleCheckboxTap(value, context);
            },
            groupValue: selectedSortOption,
            selected: selectedSortOption == SortKey.mostlikes,
          ),
          RadioListTile<SortKey>(
            title: const Text('Most Pub Points'),
            value: SortKey.mostpubpoints,
            onChanged: (SortKey? value) {
              handleCheckboxTap(value, context);
            },
            groupValue: selectedSortOption,
            selected: selectedSortOption == SortKey.mostpubpoints,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onClosePressed,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
