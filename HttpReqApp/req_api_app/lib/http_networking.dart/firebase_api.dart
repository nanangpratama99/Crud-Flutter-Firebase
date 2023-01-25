import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final add1 = TextEditingController();
final add2 = TextEditingController();
final _formKey = GlobalKey<FormState>();

class materialFirebase extends StatefulWidget {
  const materialFirebase({super.key});

  @override
  State<materialFirebase> createState() => _materialFirebaseState();
}

class _materialFirebaseState extends State<materialFirebase> {
  @override
  Widget build(BuildContext context) {
    // FIREBASE API
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person_add,
                size: 40,
              ),
            ),
          )
        ],
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: Colors.black54,
        title: Text(
          "CRUD FIREBASE",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: snapshot.data!.docs
                        .map(
                          (e) => Card(
                            color: Colors.white.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              //<-- SEE HERE
                              side: BorderSide(color: Colors.white, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 0),
                              child: ListTile(
                                textColor: Colors.white,
                                leading: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    e["nama"][0].toString().toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                title: Text(
                                  e["nama"].toString().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.amber),
                                ),
                                subtitle: Text(e["email"]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        add1.text = e["nama"];
                                        add2.text = e["email"];
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Center(
                                              child: Text("Update Data"),
                                            ),
                                            content: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller: add1,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Input your name"),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter some text';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller: add2,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Input your email"),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter some email';
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              IconButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    users.doc(e.id).update({
                                                      "nama": add1.text,
                                                      "email": add2.text,
                                                    });
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 40,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        users.doc(e.id).delete();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 40,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("error");
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(
                child: Text("Input Data"),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: add1,
                      autofocus: true,
                      decoration: InputDecoration(hintText: "Input your name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: add2,
                      autofocus: true,
                      decoration: InputDecoration(hintText: "Input your email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some email';
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      users.add({
                        "nama": add1.text,
                        "email": add2.text,
                      });
                      add1.clear();
                      add2.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        backgroundColor: Colors.amber[800],
      ),
    );
  }
}
