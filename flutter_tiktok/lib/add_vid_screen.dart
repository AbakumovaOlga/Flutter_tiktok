import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddVid extends StatefulWidget {
  const AddVid({Key? key}) : super(key: key);

  @override
  _AddVidState createState() => _AddVidState();
}

class _AddVidState extends State<AddVid> {

  String _teg = 'One';
  String _link = '';


  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Add'),
        content: Column(children: [
          TextField(
            onChanged: (String value) {
              _link = value;
            },
          ),
          DropdownButton<String>(
            items: ['One', 'Two', 'Three'].map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (newValueSelected) {
              _onDropDownItemSelected(newValueSelected!);
            },
            value: _teg,
          ),
        ]),
        actions: [
          ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Videos')
                    .add({'teg': _teg, 'link': _link});
                Navigator.of(context).pop();
              },
              child: Text('Add'))
        ],
      );
    });
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._teg = newValueSelected;
    });
  }
}
