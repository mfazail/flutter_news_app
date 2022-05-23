import 'package:allnewsatfingertips/pages/About.dart';
import 'package:allnewsatfingertips/pages/ContactUs.dart';
import 'package:allnewsatfingertips/pages/settings.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerContent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<String> items = [
    'Home',
    'Disclaimer',
    'Privacy Policy',
    'Contact Us',
    'Settings'
  ];

  DrawerContent({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Column(
          children: [
            Image.asset(
              'asset/logo.png',
              fit: BoxFit.contain,
              height: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Text("All News At Fingertips")
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (c, i) {
                Color textColor = Colors.black;
                if (i == 0) {
                  textColor = Colors.blue;
                }
                List<Function> clicks = [
                  () {
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                  () {
                    scaffoldKey.currentState!.openEndDrawer();
                    Future.delayed(Duration(milliseconds: 180), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => Pages(slug: "disclaimer"),
                        ),
                      );
                    });
                  },
                  () {
                    scaffoldKey.currentState!.openEndDrawer();
                    Future.delayed(Duration(milliseconds: 180), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => Pages(slug: "privacy-policy"),
                        ),
                      );
                    });
                  },
                  () {
                    scaffoldKey.currentState!.openEndDrawer();
                    Future.delayed(Duration(milliseconds: 180), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => ContactUs(),
                        ),
                      );
                    });
                  },
                  () {
                    scaffoldKey.currentState!.openEndDrawer();
                    Future.delayed(Duration(milliseconds: 180), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => Settings()),
                      );
                    });
                  },
                ];
                return buildNavItem(items[i], textColor, clicks[i]);
              }),
        ),
        if (MediaQuery.of(context).size.width >= 300) Spacer(),
        Consumer<States>(
          builder: (c, sn, w) => ElevatedButton(
            onPressed: () {
              sn.setSubscription(!sn.subscription);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  sn.subscription ? Colors.red : Colors.grey),
            ),
            child: Text(
              sn.subscription ? "Subscribe" : "Unsubscribe",
              style: TextStyle(
                fontSize: 19,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  InkWell buildNavItem(String text, Color textColor, onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        width: double.infinity,
        height: 50,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
