import 'package:allnewsatfingertips/pages/home.dart';
import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:allnewsatfingertips/widgets/interestChip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInterest extends StatefulWidget {
  final String rout;
  UserInterest({Key? key, required this.rout}) : super(key: key);

  @override
  _UserInterestState createState() => _UserInterestState();
}

class _UserInterestState extends State<UserInterest> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.text = Provider.of<States>(context, listen: false).email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Choose Topics",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 30,
                    spacing: 10,
                    children: [
                      InterestChip(
                        label: "World",
                        value: 3,
                      ),
                      InterestChip(
                        label: "India",
                        value: 4,
                      ),
                      InterestChip(
                        label: "Sports",
                        value: 6,
                      ),
                      InterestChip(
                        label: "Technology",
                        value: 7,
                      ),
                      InterestChip(
                        label: "Entertainment",
                        value: 499,
                      ),
                      InterestChip(
                        label: "Business",
                        value: 524,
                      ),
                      InterestChip(
                        label: "Astrology",
                        value: 5,
                      ),
                      InterestChip(
                        label: "Health & Lifestyle",
                        value: 2212,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _key,
                child: TextFormField(
                  controller: _email,
                  validator: (s) {
                    if (s != null) {
                      if (s.isEmpty) return "Email is required";
                      if (!s.contains("@")) return "Enter a valid Email";
                    } else
                      return "Email is null/Empty";
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.done,
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
        tooltip: "Done",
        onPressed: () {
          if (_key.currentState!.validate()) {
            if (widget.rout == 'settings') {
              Provider.of<States>(context, listen: false)
                  .setInterest(false, _email.text);
              Navigator.pop(context);
            } else {
              Provider.of<States>(context, listen: false)
                  .setInterest(true, _email.text);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (c) => Home(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
