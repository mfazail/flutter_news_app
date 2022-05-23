import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatelessWidget {
  ContactUs({Key? key}) : super(key: key);
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _message = TextEditingController();

  final FocusNode _emailF = FocusNode();
  final FocusNode _subjectF = FocusNode();
  final FocusNode _messageF = FocusNode();
  final FocusNode _submitF = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _name,
                validator: (s) {
                  if (s != null) {
                    if (s.isEmpty) {
                      return "Name is required";
                    }
                    if (!s.contains(RegExp(r'[a-zA-Z]')))
                      return "Name Sould not contain any Numeric or Special Character.";
                  }
                },
                keyboardType: TextInputType.name,
                onFieldSubmitted: (s) {
                  _emailF.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _email,
                validator: (s) {
                  if (s != null && !s.contains("@")) {
                    if (s.isEmpty) {
                      return "Email is required";
                    }
                    return "Enter a valid Email";
                  }
                },
                focusNode: _emailF,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (s) {
                  _subjectF.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _subject,
                validator: (s) {
                  if (s != null && s.isEmpty) {
                    return "Subject is required";
                  }
                },
                focusNode: _subjectF,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (s) {
                  _messageF.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: "Subject",
                  prefixIcon: Icon(
                    Icons.subject,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _message,
                focusNode: _messageF,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (s) {
                  _submitF.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: "Message(Optional)",
                  prefixIcon: Icon(
                    Icons.message,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                focusNode: _submitF,
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    var data = {
                      "your-name": _name.text,
                      "your-email": _email.text,
                      "your-subject": _subject.text,
                      "your-message": _message.text
                    };
                    Provider.of<States>(context, listen: false)
                        .submitForm(data);
                  }
                },
                child: Text("Submit"),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<States>(
                builder: (c, sn, w) => Text(sn.formRes),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
