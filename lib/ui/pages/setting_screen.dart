import 'package:flutter/material.dart';
import 'package:onboard/model/url_call/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/flutter.png'),
                      const Text(
                        'pub.Dev Package Searcher',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'A simple pub.dev package searcher primarily to showcase how a generic app in Flutter can be done. This also serves as a test run o the usage of Riverpod. Credits goes to the pub.dev team for allowing public consumption of their APIs',
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: ElevatedButton(
                              child: const Text('Visit Flutter.dev'),
                              onPressed: () {
                                launchURL('https://flutter.dev');
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              child: const Text('Visit pub.dev'),
                              onPressed: () {
                                launchURL('https://pub.dev');
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              child: const Text('Visit riverpod'),
                              onPressed: () {
                                launchURL('https://riverpod.dev');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
