import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class TagsScreen extends StatefulWidget {
  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  String _teg='';



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Tik-tok tags'),
        centerTitle: true
      ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text('Add'),
              content:
                  TextField(
                    onChanged: (String value){
                      _teg=value;
                    },

                  ),
              actions: [
                ElevatedButton(onPressed: (){
                  FirebaseFirestore.instance.collection('Tags').add({'teg':_teg,});
                  Navigator.of(context).pop();
                }, child: Text('Add'))
              ],
            );
          });
        },
          child: Icon(
            Icons.add_box,
          ),
        ),
    body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Tags').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) return Text('No_data');
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index){
              return Dismissible(
                key: Key(snapshot.data!.docs[index].id),
                child: Card(
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index].get('teg')),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.blue,),
                      onPressed: () {
                        FirebaseFirestore.instance.collection('Tags').doc(snapshot.data!.docs[index].id).delete();
                      },
                    ) ,
                  ),
                ),
                onDismissed: (direction){
                  FirebaseFirestore.instance.collection('Tags').doc(snapshot.data!.docs[index].id).delete();
                },
              );
            });
      },
    ),
    );
  }
}
