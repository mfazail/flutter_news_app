import 'package:allnewsatfingertips/Api/Wp_api.dart';
import 'package:allnewsatfingertips/models/Post.dart';
import 'package:allnewsatfingertips/pages/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class MyCard extends StatelessWidget {
  final Post post;

  const MyCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => Details(post: post),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.grey[200]!,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.imageUrl.isNotEmpty)
                  Image.network(
                    post.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (c, o, s) {
                      return Center(child: Text("Error Loading Images"));
                    },
                  ),
                if (post.imageUrl.isEmpty)
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
                  ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "News At Finger Tips",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      getDate(post.date),
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                Spacer(),
                Text(
                  HtmlUnescape().convert(post.title),
                  style: TextStyle(fontSize: 20),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                getCategory(post.categories[0]),
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
