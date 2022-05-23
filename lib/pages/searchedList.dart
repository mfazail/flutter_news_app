import 'package:allnewsatfingertips/widgets/myCard.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:allnewsatfingertips/widgets/shimmerCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedList extends StatefulWidget {
  final String title;

  const SearchedList({Key? key, required this.title}) : super(key: key);

  @override
  _SearchedListState createState() => _SearchedListState();
}

class _SearchedListState extends State<SearchedList> {
  ScrollController _scrollController = ScrollController();
  int page = 1;
  late States states;
  List<dynamic> posts = [];
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
          fetchSearch();
        }
      }
    });
    fetchSearch();
  }

  Future<void> fetchSearch() async {
    posts.addAll(await states.fetchSearchPost(widget.title, page));
    setState(() {
      isLastPage = states.totalSearchPages == 0
          ? true
          : posts.length == states.totalSearchPages;
      page++;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        brightness: Brightness.dark,
      ),
      body: Container(
        width: width,
        height: height,
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              states.totalSearchPages = 0;
              posts = [];
              page = 1;
            });
            return fetchSearch();
          },
          child: posts.length == 0
              ? Center(
                  child: ListView.builder(
                      itemCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (c, i) {
                        return ShimmerCard();
                      }),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length + (isLastPage ? 0 : 1),
                  itemBuilder: (c, i) {
                    if (posts.length > 5 && i == posts.length) {
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
                                fetchSearch();
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
                    } else
                      return MyCard(
                        post: posts[i],
                      );
                  },
                ),
        ),
      ),
    );
  }
}
