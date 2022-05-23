import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Pages extends StatelessWidget {
  final String slug;
  const Pages({Key? key, required this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            slug == "disclaimer" ? "Disclaimer" : "Privacy Policy",
          ),
        ),
        body: FutureBuilder<String>(
            future: Provider.of<States>(context, listen: false).fetchPage(slug),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == "You are offline.")
                  return Center(child: Text(snapshot.data!));
                return SingleChildScrollView(
                  child: Html(
                    data: snapshot.data,
                    onLinkTap: (url, c, m, e) async {
                      await canLaunch(url!)
                          ? await launch(url)
                          : throw 'Could not launch $url';
                    },
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
