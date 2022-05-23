import 'package:allnewsatfingertips/pages/searchedList.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarSearch extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppBarSearch({Key? key, required this.scaffoldKey}) : super(key: key);
  @override
  _AppBarSearchState createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  bool isSearching = false;
  var fNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      title: !isSearching
          ? Row(
              children: [
                Image.asset(
                  'asset/logo.png',
                  fit: BoxFit.contain,
                  height: 32,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  width < 300 ? 'ANAF' : 'All News At Finger Tips',
                ),
              ],
            )
          : SizedBox.shrink(),
      leading: !isSearching
          ? IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                if (!widget.scaffoldKey.currentState!.isDrawerOpen) {
                  widget.scaffoldKey.currentState?.openDrawer();
                }
              },
            )
          : SizedBox.shrink(),
      actions: [
        isSearching
            ? Expanded(
                child: TextField(
                  focusNode: fNode,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.words,
                  cursorHeight: 22,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onSubmitted: (v) async {
                    setState(() {
                      isSearching = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => SearchedList(
                          title: v,
                        ),
                      ),
                    );
                  },
                ),
              )
            : SizedBox.shrink(),
        IconButton(
          icon: isSearching
              ? Icon(
                  Icons.close,
                )
              : Icon(Icons.search),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
            fNode.requestFocus();
          },
        )
      ],
    );
  }
}
