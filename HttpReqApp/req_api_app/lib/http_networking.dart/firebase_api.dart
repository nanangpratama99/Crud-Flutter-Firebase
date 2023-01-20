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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Crud Firebase",
          style: TextStyle(color: Colors.purple),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  children: snapshot.data!.docs
                      .map(
                        (e) => Container(
                          child: ListTile(
                            textColor: Colors.purple,
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              child: Text(
                                e["nama"][0],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(e["nama"]),
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
                                            icon: Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    users.doc(e.id).delete();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
