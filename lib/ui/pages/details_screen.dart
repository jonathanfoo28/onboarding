import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:onboard/generated/generated/intl/timeago.dart';
import 'package:onboard/model/api/package_details.dart';
import 'package:onboard/model/api/publisher_detail.dart';
import 'package:onboard/viewmodel/provider/favourite_provider.dart';

class DetailsPage extends StatefulWidget {
  final String pname;
  const DetailsPage({super.key, required this.pname});

  @override
  State<DetailsPage> createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  PackageDetails? package;
  PublisherID? pid;
  bool isLoading = false;

  void fetchPackages(String packagename) async {
    String url = 'https://pub.dev/api/packages/$packagename';
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      PackageDetails package = PackageDetails.fromJson(jsonData);

      setState(() {
        this.package = package;
      });
    } else {
      // ignore: avoid_print
      print(
          'Failed to fetch data from the API. Status code: ${response.statusCode}');
    }
    setState(() {
      isLoading = false;
    });
  }

  void fetchData(String packagename) async {
    final url = 'https://pub.dev/api/packages/$packagename/publisher';
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData.containsKey('publisherId')) {
        PublisherID pubID = PublisherID.fromJson(jsonData);
        setState(() {
          pid = pubID;
        });
      }
    } else {
      // ignore: avoid_print
      print('Failed to fetch data');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPackages(widget.pname);
    fetchData(widget.pname);
  }

  @override
  Widget build(BuildContext context) {
    final favouriteProvider = Provider.of<FavouriteProvider>(context);
    final isFavourited =
        favouriteProvider.isPackageFavorited(package?.name ?? '');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Package Details'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${package?.name} ${package?.latestVersion.version}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: IconButton(
                            icon: const Icon(Icons.copy),
                            color: Colors.grey,
                            onPressed: () async {
                              const snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  'Copied to Clipboard',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              await Clipboard.setData(
                                ClipboardData(
                                    text:
                                        ('https://pub.dev/api/packages/${package?.name}')),
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            favouriteProvider
                                .toggleFavourite(package?.name ?? '');
                          },
                          child: Icon(
                            isFavourited
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: isFavourited ? Colors.red : null,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                          'Published  ${formatTimeAgo(package?.latestVersion.publishedDate ?? '')} | '),
                      Text(
                        pid?.publisherID ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(package?.latestVersion.pubspec.description ?? ''),
                ),
              ]));
  }
}
