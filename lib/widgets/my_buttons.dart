import 'package:flutter/material.dart';

class MyButtons extends StatefulWidget {
  final String text;
  final Function() onPress;
  final IconData icon;

  const MyButtons(
      {Key? key, required this.text, required this.onPress, required this.icon})
      : super(key: key);
  @override
  _MyButtonsState createState() => _MyButtonsState();
}

class _MyButtonsState extends State<MyButtons> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: widget.onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(widget.text),
            ),
          ],
        ),
      ),
    );
  }
}
