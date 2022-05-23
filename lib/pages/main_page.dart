import 'package:allnewsatfingertips/models/Post.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:allnewsatfingertips/widgets/myCard.dart';
import 'package:allnewsatfingertips/widgets/shimmerCard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.category}) : super(key: key);
  final int category;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController _scrollController = ScrollController();
  int page = 1;
  List posts = [];
  late States states;
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    states = Provider.of<States>(context, listen: false);
    _scrollController.addListener(() {
      var max = _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels == max) {
        if (!posts.contains("You are offline") && !isLoading) {
          isLoading = true;
          fetchPost();
        }
      }
    });
    fetchPost();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> fetchPost() async {
    if (this.mounted) {
      List<dynamic> temp = [];
      switch (widget.category) {
        case 0:
          {
            temp.addAll(await Provider.of<States>(context, listen: false)
                .fetchInterestPost(page));
            break;
          }
        case 1:
          {
            temp.addAll(await Provider.of<States>(context, listen: false)
                .fetchLatestPosts(page));
            break;
          }
        default:
          {
            temp.addAll(await Provider.of<States>(context, listen: false)
                .fetchCategoryPost(widget.category, page));
          }
      }
      await states.initialization.then((value) async {
        for (int i = 3; i < temp.length; i += 5) {
          temp.insert(
            i,
            BannerAd(
              size: AdSize.largeBanner,
              adUnitId: states.adUnit,
              listener: states.adlistener,
              request: AdRequest(),
            )..load(),
          );
        }

        print(states.totalPages);
        setState(() {
          posts.addAll(temp);
          isLastPage = states.totalPages == 0
              ? true
              : posts.length - (page * 2) == states.totalPages;
          page++;
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {
            states.totalPages = 0;
            page = 1;
            posts = [];
          });
          return fetchPost();
        },
        child: posts.length == 0
            ? ListView.builder(
                itemCount: 3,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) => ShimmerCard(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: posts.length + (isLastPage ? 0 : 1),
                itemBuilder: (c, i) {
                  if (i > 5 && i == posts.length) {
                    return ShimmerCard();
                  } else if (posts[i] is String && isLastPage) {
                    return Container(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(posts[i].toString()),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLoading = false;
                                page = 1;
                                posts = [];
                              });
                              fetchPost();
                            },
                            child: Text(
                              "Refresh",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (posts[i] is Post) {
                    return MyCard(
                      post: posts[i] as Post,
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      height: 100,
                      child: AdWidget(ad: posts[i] as BannerAd),
                    );
                  }
                },
              ),
      ),
    );
  }
}
