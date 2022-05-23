import 'package:allnewsatfingertips/stateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterestChip extends StatefulWidget {
  final String label;
  final int value;
  InterestChip({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  _InterestChipState createState() => _InterestChipState();
}

class _InterestChipState extends State<InterestChip> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isSelected = false;
  @override
  void initState() {
    super.initState();
    _checkState();
  }

  _checkState() async {
    SharedPreferences prefs = await _prefs;
    if (prefs.getStringList('interest') != null) {
      List<String> l = prefs.getStringList('interest')!;
      if (l.contains(widget.value.toString())) {
        setState(() {
          _isSelected = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          _isSelected = !_isSelected;
        });
        if (_isSelected) {
          Provider.of<States>(context, listen: false)
              .interest
              .add(widget.value.toString());
        } else {
          Provider.of<States>(context, listen: false)
              .interest
              .remove(widget.value.toString());
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Text(
          widget.label,
          style: TextStyle(color: _isSelected ? Colors.blue : Colors.white),
        ),
        decoration: BoxDecoration(
          color: _isSelected ? Colors.white : Colors.transparent,
          border: Border.all(color: _isSelected ? Colors.blue : Colors.white),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}
