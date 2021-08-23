import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _teg='';
  String _link='';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text('Tik-tok videos'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){
                 // Navigator.pop(context);
                  Navigator.pushNamed(context, '/tags');
              },
                icon: Icon(Icons.post_add))
          ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Text('No_data');
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index){
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index].get('link')),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.blue,),
                        onPressed: () {
                          FirebaseFirestore.instance.collection('Videos').doc(snapshot.data!.docs[index].id).delete();
                        },
                      ) ,
                    ),
                  ),
                  onDismissed: (direction){
                    FirebaseFirestore.instance.collection('Videos').doc(snapshot.data!.docs[index].id).delete();
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Tags').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index){
                          return AlertDialog(
                            title: Text('Add'),
                            content:Column(
                                children:[
                                  TextField(
                                    onChanged: (String value){
                                      _link=value;
                                    },
                                  ),
                                  DropdownButton<String>(
                                    items:snapshot.data!.docs.{
                          return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          );
                          }).toList(),
                                    onChanged: (_) {},
                                  )
                                ]),
                            actions: [
                              ElevatedButton(onPressed: (){
                                FirebaseFirestore.instance.collection('Videos').add({'teg':_teg, 'link':_link});
                                Navigator.of(context).pop();
                              }, child: Text('Add'))
                            ],
                          );
                        }
                        );
                  });
            });
        },
        child: Icon(
          Icons.add_box,
        ),
      ),
    );
  }


}

