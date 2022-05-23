import 'package:allnewsatfingertips/models/Post.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

class CommentDetail extends StatefulWidget {
  final Post post;
  CommentDetail({Key? key, required this.post}) : super(key: key);

  @override
  _CommentDetailState createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  TextEditingController _name = TextEditingController();

  TextEditingController _email = TextEditingController();

  TextEditingController _comment = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<States>(context, listen: false).fetchComment(widget.post.id);
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _comment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(HtmlUnescape().convert(widget.post.title)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (s) {
                        if (s != null) {
                          if (s.isEmpty) return "Name is Required";
                          if (!s.contains(RegExp('[a-zA-Z]')))
                            return "Name Sould not contain any Numeric or Special Character.";
                        }
                      },
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: InputBorder.none,
                      ),
                    ),
                    TextFormField(
                      validator: (s) {
                        if (s != null && !s.contains("@")) {
                          if (s.isEmpty) return "Email is required";
                          return "Enter a valid email";
                        }
                      },
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: " Email",
                        border: InputBorder.none,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (s) {
                              if (s != null && s.isEmpty) {
                                return "Comment is required";
                              }
                            },
                            controller: _comment,
                            cursorHeight: 24,
                            decoration: InputDecoration(
                              hintText: " Comment",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              Provider.of<States>(context, listen: false)
                                  .postComment(
                                _name.text,
                                _email.text,
                                _comment.text,
                                widget.post.id,
                              );
                              Provider.of<States>(context, listen: false)
                                  .fetchComment(widget.post.id);
                              _name.text = "";
                              _email.text = "";
                              _comment.text = "";
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Consumer<States>(builder: (c, sn, w) {
              if (sn.commentError.isEmpty) {
                return SizedBox.shrink();
              }
              if (sn.commentError == "succeed") {
                return Text(
                  "Comment Posted",
                  style: TextStyle(color: Colors.blue),
                );
              }
              return Text(
                sn.commentError,
                style: TextStyle(color: Colors.red),
              );
            }),
            Divider(
              color: Colors.blue,
              height: 19,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Consumer<States>(
                builder: (c, sn, _) {
                  if (sn.comments.length <= 0) {
                    return Center(
                      child: Text(
                        "Be the First to comment",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: sn.comments.length,
                    itemBuilder: (co, i) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8, top: 10),
                          child: Text(
                            sn.comments[i].authorName,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Html(
                          data: sn.comments[i].content,
                          style: {
                            'p': Style.fromTextStyle(
                              TextStyle(
                                color: Colors.grey[700],
                                fontSize: 17,
                              ),
                            ),
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
