import 'package:allnewsatfingertips/Api/Wp_api.dart';
import 'package:allnewsatfingertips/pages/details.dart';
import 'package:allnewsatfingertips/pages/main_page.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:allnewsatfingertips/widgets/appbar_search.dart';
import 'package:allnewsatfingertips/widgets/drawer_content.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:allnewsatfingertips/globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 9, vsync: this);
    super.initState();
    Provider.of<States>(context, listen: false).fetchInterestPost(1);
    initOS();
  }

  void initOS() async {
    OneSignal.shared.setNotificationOpenedHandler((result) async {
      var data = result.notification.additionalData!["post_id"].toString();
      globals.appNavigator!.currentState!.push(
        MaterialPageRoute(
          builder: (c) => Details(
            title: data,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerContent(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 55),
        child: AppBarSearch(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            constraints: BoxConstraints(maxHeight: 60),
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              physics: BouncingScrollPhysics(),
              tabs: [
                Tab(
                  text: cat[0],
                ),
                Tab(
                  text: cat[1],
                ),
                Tab(
                  text: cat[2],
                ),
                Tab(
                  text: cat[3],
                ),
                Tab(
                  text: cat[4],
                ),
                Tab(
                  text: cat[5],
                ),
                Tab(
                  text: cat[6],
                ),
                Tab(
                  text: cat[7],
                ),
                Tab(
                  text: cat[8],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: [
                MainPage(category: categories[0]),
                MainPage(category: categories[1]),
                MainPage(category: categories[2]),
                MainPage(category: categories[3]),
                MainPage(category: categories[4]),
                MainPage(category: categories[5]),
                MainPage(category: categories[6]),
                MainPage(category: categories[7]),
                MainPage(category: categories[8]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
