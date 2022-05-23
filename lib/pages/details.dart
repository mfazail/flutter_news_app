import 'package:allnewsatfingertips/Api/Wp_api.dart';
import 'package:allnewsatfingertips/models/Post.dart';
import 'package:allnewsatfingertips/pages/CommentsDetail.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:allnewsatfingertips/widgets/embedWebView.dart';
import 'package:allnewsatfingertips/widgets/myCard.dart';
import 'package:allnewsatfingertips/widgets/my_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Details extends StatefulWidget {
  late Post? post;
  final String? title;

  Details({Key? key, this.post, this.title}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  PageController _pageController = PageController(viewportFraction: 0.9);
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    if (widget.post == null) {
      Provider.of<States>(context, listen: false)
          .fetchPost(widget.title!)
          .then((post) {
        if (post is Post) {
          widget.post = post;
        } else if (post is bool) {
          _isOffline = post;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post == null ? "" : HtmlUnescape().convert(widget.post!.title),
        ),
        brightness: Brightness.dark,
      ),
      body: _isOffline
          ? Center(
              child: Text("You are offline"),
            )
          : SingleChildScrollView(
              physics: widget.post == null
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (widget.post == null)
                    Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.grey[300]!,
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.white,
                      ),
                    )
                  else if (widget.post!.imageUrl.isEmpty)
                    Container(
                      width: double.infinity,
                      height: 250,
                      alignment: Alignment.center,
                      child: Text(
                        "Image Not Available",
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 25,
                        ),
                      ),
                    )
                  else
                    Image.network(
                      widget.post!.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.post == null)
                    Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.grey[300]!,
                      child: Container(
                        width: double.infinity,
                        height: 10,
                        color: Colors.white,
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "News At Finger Tips",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            getDate(widget.post!.date),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.post != null)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyButtons(
                            text: 'Like',
                            onPress: () {},
                            icon: Icons.thumb_up_alt_outlined,
                          ),
                          MyButtons(
                            text: "Comments",
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) =>
                                      CommentDetail(post: widget.post!),
                                ),
                              );
                            },
                            icon: Icons.comment_outlined,
                          ),
                          MyButtons(
                            text: 'Share',
                            onPress: () {
                              if (widget.post != null)
                                Share.share(
                                    '${HtmlUnescape().convert(widget.post!.title)}\n\n${widget.post!.link}');
                            },
                            icon: Icons.share,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.post == null)
                    Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.grey[300]!,
                      child: Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        HtmlUnescape().convert(widget.post!.title),
                        style: TextStyle(color: Colors.black87, fontSize: 25),
                      ),
                    ),
                  if (widget.post == null)
                    Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.grey[300]!,
                      child: Container(
                        height: 700,
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Html(
                        data: widget.post!.content,
                        onLinkTap: (url, c, attr, e) async {
                          await canLaunch(url!)
                              ? await launch(url)
                              : throw 'Could not launch $url';
                        },
                        style: {
                          'p': Style.fromTextStyle(
                            TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              height: 1.7,
                            ),
                          ),
                          'div': Style.fromTextStyle(
                            TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              height: 1.7,
                            ),
                          ),
                        },
                        customRender: {
                          "blockquote": (c, w) {
                            return EmbedWebView(
                              child: c,
                            );
                          }
                        },
                        navigationDelegateForIframe: (r) {
                          return NavigationDecision.navigate;
                        },
                      ),
                    ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyButtons(
                          text: 'Like',
                          onPress: () {},
                          icon: Icons.thumb_up_alt_outlined,
                        ),
                        MyButtons(
                          text: "Comments",
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) =>
                                    CommentDetail(post: widget.post!),
                              ),
                            );
                          },
                          icon: Icons.comment_outlined,
                        ),
                        MyButtons(
                          text: 'Share',
                          onPress: () {
                            if (widget.post != null)
                              Share.share(
                                  '${HtmlUnescape().convert(widget.post!.title)}\n\n${widget.post!.link}');
                          },
                          icon: Icons.share,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      "Related News",
                      style: TextStyle(color: Colors.blue, fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.post != null)
                    Container(
                      width: double.infinity,
                      height: 370,
                      child: FutureBuilder<List<dynamic>>(
                          future: Provider.of<States>(context, listen: false)
                              .fetchCategoryPost(widget.post!.categories[0], 1),
                          builder: (c, sn) {
                            if (!sn.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (sn.data![0] is String)
                              return Center(
                                child: Text("You are offline"),
                              );
                            return PageView.builder(
                              controller: PageController(viewportFraction: 0.9),
                              itemCount: 10,
                              itemBuilder: (c, i) {
                                if (sn.data![i] is BannerAd) {
                                  i++;
                                }
                                return MyCard(post: sn.data![i] as Post);
                              },
                            );
                          }),
                    ),
                ],
              ),
            ),
    );
  }
}
