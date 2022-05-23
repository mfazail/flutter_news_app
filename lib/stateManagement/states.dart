import 'dart:io';
import 'package:allnewsatfingertips/Api/Wp_api.dart';
import 'package:allnewsatfingertips/models/Comments.dart';
import 'package:allnewsatfingertips/models/Post.dart';
import 'package:allnewsatfingertips/models/SearchId.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class States extends ChangeNotifier {
  Future<InitializationStatus> initialization;
  States(this.initialization);

  String testAdUnitA = "ca-app-pub-3940256099942544/6300978111";
  String testAdUnitI = "ca-app-pub-3940256099942544/2934735716";
  String adUnitA = "ca-app-pub-8831871394978335/3785593651";
  String get adUnit => Platform.isAndroid ? testAdUnitA : testAdUnitI;

  BannerAdListener get adlistener => _adListener;

  BannerAdListener _adListener = BannerAdListener(
    onAdFailedToLoad: (ad, e) => print(e),
  );
  Connectivity connectivity = Connectivity();
  int cat = 0;
  List post = [];
  List searchPost = [];
  int get getCategorty => cat;
  int totalPages = 0;
  int totalSearchPages = 0;
  String searched = '';
  List<Comments> comments = [];
  String commentError = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> interest = [];
  String email = "";

  bool _subscription = false;
  bool get subscription => _subscription;

  String formRes = "";

  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<List<dynamic>> fetchInterestPost(page) async {
    if (!await checkNetwork()) {
      totalPages = 0;
      return ["You are offline"];
    }
    SharedPreferences pref = await _prefs;
    if (pref.getStringList('interest') == null) {
      return [];
    }
    if (interest.isEmpty) {
      interest = pref.getStringList('interest')!;
    }
    var category = interest.join(',');
    var url = Uri.parse(
        "$baseUrl/posts?categories=$category&_fields=id,date,title,content,categories,jetpack_featured_media_url,link&page=$page");
    try {
      var response =
          await http.get(url, headers: {'content-type': 'application/json'});
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      totalPages = int.tryParse(response.headers["x-wp-total"]!) ?? 0;
      List<dynamic> temp =
          parsed.map<Post>((json) => Post.fromJson(json)).toList();
      return temp;
    } catch (e) {
      print(e);
      return ["Somrthing went wrong"];
    }
  }

  Future<List<dynamic>> fetchLatestPosts(p) async {
    if (!await checkNetwork()) {
      totalPages = 0;
      return ["You are offline"];
    }
    var url = Uri.parse(
        "$baseUrl/posts?_fields=id,date,title,content,categories,jetpack_featured_media_url,link&page=$p");
    try {
      var response =
          await http.get(url, headers: {'content-type': 'application/json'});
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      print(parsed);
      totalPages = int.tryParse(response.headers['x-wp-total']!) ?? 0;
      List<dynamic> temp =
          parsed.map<Post>((json) => Post.fromJson(json)).toList();

      return temp;
    } catch (error) {
      print(error);
      post = [];
      return ["Something went wrong"];
    }
  }

  Future<List<dynamic>> fetchCategoryPost(int category, int page) async {
    if (!await checkNetwork()) {
      totalPages = 0;
      return ["You are offline"];
    }
    if (category != cat) {
      totalPages = 0;
    }
    var url = Uri.parse(
        "$baseUrl/posts?categories=$category&_fields=id,date,title,content,categories,jetpack_featured_media_url,link&page=$page");
    try {
      var response =
          await http.get(url, headers: {'content-type': 'application/json'});
      totalPages = int.tryParse(response.headers['x-wp-total']!) ?? 0;
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      List<dynamic> temp =
          parsed.map<Post>((json) => Post.fromJson(json)).toList();
      return temp;
    } catch (e) {
      print(e);
      return ["Something went wrong"];
    }
  }

  Future<List<dynamic>> fetchSearchPost(search, page) async {
    if (!await checkNetwork()) {
      totalSearchPages = 0;
      return ["You are offline"];
    }
    List<SearchId> postIds = [];
    var url = Uri.parse("$baseUrl/search?search=$search&_fields=id&page=$page");
    try {
      var response =
          await http.get(url, headers: {'content-type': 'application/json'});
      totalSearchPages = int.tryParse(response.headers['x-wp-total']!) ?? 0;
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      postIds =
          parsed.map<SearchId>((json) => SearchId.fromJson(json)).toList();
      return await getPostWithID(postIds);
    } catch (e) {
      return ["Something went Wrong"];
    }
  }

  Future<List<Post>> getPostWithID(List<SearchId> postIds) async {
    List<Post> temp = [];
    for (int i = 0; i < postIds.length; i++) {
      var url = Uri.parse(
          "$baseUrl/posts/${postIds[i].id}?fields=id,date,title,content,categories,jetpack_featured_media_url");
      try {
        var response =
            await http.get(url, headers: {'content-type': 'application/json'});
        var parsed = jsonDecode(response.body);
        Post _post = Post(
          id: parsed['id'],
          date: parsed['date'],
          title: parsed['title']['rendered'],
          content: parsed['content']['rendered'],
          categories: parsed['categories'],
          imageUrl: parsed['jetpack_featured_media_url'],
          link: parsed['link'],
        );
        temp.add(_post);
      } catch (e) {
        print(e);
      }
    }
    return temp;
  }

  void fetchComment(postId) async {
    if (!await checkNetwork()) {
      return;
    }
    if (comments.length > 0) {
      comments = [];
    }
    var url = Uri.parse(
        "$baseUrl/comments?post=$postId&_fields=id,author_name,date,content,status");
    try {
      var response =
          await http.get(url, headers: {'content-type': 'application/json'});
      var parsed = jsonDecode(response.body);
      comments =
          parsed.map<Comments>((json) => Comments.fromJson(json)).toList();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void postComment(String name, String email, String comment, postId) async {
    if (!await checkNetwork()) {
      commentError = "You are offline.";
      notifyListeners();
      return;
    }
    if (name.isEmpty || email.isEmpty || comment.isEmpty) {
      return;
    }
    print("$name,$email,$comment,$postId");
    var url = Uri.parse("$baseUrl/comments");
    var res = await http.post(url, body: {
      "post": postId.toString(),
      "author_name": name,
      "author_email": email,
      "content": comment,
    });
    var parsed = jsonDecode(res.body);
    if (res.statusCode == 400) {
      commentError = parsed["data"]["params"]["author_email"];
    }
    if (res.statusCode == 200) {
      commentError = "succeed";
    }
    if (res.statusCode == 500) {
      commentError = "Server Error";
    }
    notifyListeners();
  }

  void setInterest(bool first, String email) async {
    SharedPreferences prefs = await _prefs;
    OneSignal.shared.setEmail(email: email);
    prefs.setStringList('interest', interest);
    prefs.setString('email', email);
    post = [];
    if (!first) {
      fetchInterestPost(1);
    }
  }

  void getEmail() async {
    SharedPreferences prefs = await _prefs;
    email = prefs.getString("email") ?? "Email not Available";
  }

  Future<dynamic> fetchPost(String postID) async {
    if (!await checkNetwork()) {
      return true;
    }
    var _url = Uri.parse(
        "$baseUrl/posts/$postID?fields=id,date,title,content,categories,jetpack_featured_media_url");
    try {
      var response =
          await http.get(_url, headers: {'content-type': 'application/json'});
      var _parsed = jsonDecode(response.body);
      Post _post = Post(
        id: _parsed['id'],
        date: _parsed['date'],
        title: _parsed['title']['rendered'],
        content: _parsed['content']['rendered'],
        categories: _parsed['categories'],
        imageUrl: _parsed['jetpack_featured_media_url'],
        link: _parsed['link'],
      );
      print(_post);
      return _post;
    } catch (e) {
      print(e);
    }
    return {} as Post;
  }

  Future<String> fetchPage(String slug) async {
    if (!await checkNetwork()) {
      return "You are offline.";
    }
    var url = Uri.parse("$baseUrl/pages?slug=$slug&_fields=title,content");
    try {
      var response =
          await http.get(url, headers: {'content-type': 'application/json'});
      var parsed = jsonDecode(response.body);
      return parsed[0]['content']['rendered'] as String;
    } catch (e) {
      print(e);
    }
    return "Error Fetching Data!";
  }

  void setSubscription(value) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool('subscription', value);
    OneSignal.shared.disablePush(value);
    _subscription = value;
    notifyListeners();
  }

  void getSubscription() async {
    SharedPreferences prefs = await _prefs;
    _subscription = prefs.getBool('subscription') ?? false;
    print(_subscription);
  }

  void submitForm(Object data) async {
    if (!await checkNetwork()) {
      formRes = "You are offline.";
      notifyListeners();
      return;
    }
    var url = Uri.parse(
        "https://allnewsatfingertips.com/wp-json/contact-form-7/v1/contact-forms/10/feedback");
    try {
      var response = await http.post(url, body: data);
      var parsed = jsonDecode(response.body);
      formRes = parsed["message"].toString();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
