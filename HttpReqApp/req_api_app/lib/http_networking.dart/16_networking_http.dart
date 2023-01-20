import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Module16App extends StatefulWidget {
  const Module16App({super.key});

  @override
  State<Module16App> createState() => _Module16AppState();
}

class _Module16AppState extends State<Module16App> {
  @override
  Widget build(BuildContext context) {
    final add1 = TextEditingController();
    final add2 = TextEditingController();
    final add3 = TextEditingController();

    // < ---- Key Validasi Input ----- >
    final _formKey = GlobalKey<FormState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF764abc),
          title: Text("Get Data From Api"),
        ),
        body: Container(child: UsingTheData()),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF764abc),
          onPressed: () {
            // postData({"name": "post method", "email": "testpost@gmail.com"});
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
                        decoration:
                            InputDecoration(hintText: "Input your name"),
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
                        decoration:
                            InputDecoration(hintText: "Input your email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some email';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: add3,
                        autofocus: true,
                        decoration:
                            InputDecoration(hintText: "Input your gender"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        postData(
                          {
                            "nama": add1.text,
                            "email": add2.text,
                            "gender": add3.text,
                            "password": "",
                          },
                        );
                        add1.clear();
                        add2.clear();
                        add3.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrintResponseBody extends StatelessWidget {
  Future<http.Response> getData() async {
    final response =
        await http.get(Uri.parse("http://192.168.0.129:8082/api/user/getAll"));
    // await http.get(Uri.parse("https://reqres.in/api/users?per_page=15"));
    // await Future.delayed(const Duration(seconds: 2));

    return response;
  }

  const PrintResponseBody({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.body);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(child: const CircularProgressIndicator());
        ;
      },
    );
  }
}

class UsingTheData extends StatefulWidget {
  UsingTheData({super.key});

  @override
  State<UsingTheData> createState() => _UsingTheDataState();
}

class _UsingTheDataState extends State<UsingTheData> {
  Future<http.Response> getData() async {
    final response =
        await http.get(Uri.parse("http://192.168.0.129:8082/api/user/getAll"));
    // await http.get(Uri.parse("https://reqres.in/api/users?per_page=15"));
    // await Future.delayed(const Duration(seconds: 2));
    setState(() {
      response;
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    // FIREBASE CONFIGURE
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection("users");

    // INPUT TEXT CONTROLLER
    final add1 = TextEditingController();
    final add2 = TextEditingController();
    final add3 = TextEditingController();

    // < ---- Key Validasi Input ----- >
    final _formKey = GlobalKey<FormState>();

// FUTURE BUILDER
    // return FutureBuilder(
    //   future: getData().then((value) => value.body),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       List<dynamic> json = jsonDecode(snapshot.data!);
    //       // List<dynamic> json = jsonDecode(snapshot.data!)["data"];
    //       return ListView.builder(
    //         itemCount: json.length,
    //         itemBuilder: (context, index) {
    //           return ListTile(
    //               leading: CircleAvatar(
    //                 backgroundColor: Color(0xFF764abc),
    //                 child: Text("${json[index]["nama"][0] ?? 'A'}"),
    //               ),
    //               title: Text("${json[index]["nama"] ?? 'A'}"),
    //               subtitle: Text("${json[index]["email"]}"),
    //               onTap: () {
    //                 print("nama: ${json[index]["nama"] ?? ''}");
    //                 print("email: ${json[index]["email"]}");
    //               },
    //               trailing: Row(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   IconButton(
    //                     onPressed: () {
    //                       add1.text = json[index]["nama"];
    //                       add2.text = json[index]["email"];
    //                       add3.text = json[index]["gender"];
    //                       showDialog(
    //                         context: context,
    //                         builder: (context) => AlertDialog(
    //                           title: Center(
    //                             child: Text("Update Data"),
    //                           ),
    //                           content: Form(
    //                             key: _formKey,
    //                             child: Column(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 TextFormField(
    //                                   controller: add1,
    //                                   autofocus: true,
    //                                   decoration: InputDecoration(
    //                                       hintText: "Update your name"),
    //                                   validator: (value) {
    //                                     if (value == null || value.isEmpty) {
    //                                       return 'Please enter some text';
    //                                     }
    //                                     return null;
    //                                   },
    //                                 ),
    //                                 TextFormField(
    //                                   controller: add2,
    //                                   autofocus: true,
    //                                   decoration: InputDecoration(
    //                                       hintText: "Update your email"),
    //                                   validator: (value) {
    //                                     if (value == null || value.isEmpty) {
    //                                       return 'Please enter some email';
    //                                     } else if (!EmailValidator.validate(
    //                                         value)) {
    //                                       return 'Please enter a valid email';
    //                                     }
    //                                     return null;
    //                                   },
    //                                 ),
    //                                 TextFormField(
    //                                   controller: add3,
    //                                   autofocus: true,
    //                                   decoration: InputDecoration(
    //                                       hintText: "Update your gender"),
    //                                   // validator: (value) {
    //                                   //   if (value == null || value.isEmpty) {
    //                                   //     return 'Please enter some email';
    //                                   //   } else if (!EmailValidator.validate(value)) {
    //                                   //     return 'Please enter a valid email';
    //                                   //   }
    //                                   //   return null;
    //                                   // },
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           actions: [
    //                             IconButton(
    //                               onPressed: () {
    //                                 if (_formKey.currentState!.validate()) {
    //                                   updateData(json[index]["id"], {
    //                                     "nama": add1.text,
    //                                     "email": add2.text,
    //                                     "gender": add3.text,
    //                                     "password": "",
    //                                   });
    //                                   add1.clear();
    //                                   add2.clear();
    //                                   add3.clear();
    //                                   Navigator.of(context).pop();
    //                                 }
    //                               },
    //                               icon: IconButton(
    //                                 onPressed: () {},
    //                                 icon: Icon(Icons.add),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       );
    //                     },
    //                     icon: Icon(Icons.add_circle_outline_rounded),
    //                   ),
    //                   IconButton(
    //                     onPressed: () {
    //                       deleteData(json[index]["id"]);
    //                     },
    //                     icon: Icon(Icons.remove_circle_outline),
    //                   )
    //                 ],
    //               ));
    //         },
    //       );
    //     } else if (snapshot.hasError) {
    //       return Text('${snapshot.error}');
    //     }
    //     return Center(child: const CircularProgressIndicator());
    //   },
    // );

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!.docs
                .map(
                  (e) => ListTile(
                    leading: CircleAvatar(
                      child: Text(e["nama"][0]),
                    ),
                    title: Text(e["nama"]),
                    subtitle: Text(e["email"]),
                  ),
                )
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Text("error");
        } else {
          return Text("Loading");
        }
      },
    );

    //   future: getData().then((value) => value.body),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       List<dynamic> json = jsonDecode(snapshot.data!);
    //       // List<dynamic> json = jsonDecode(snapshot.data!)["data"];
    //       return ListView.builder(
    //         itemCount: json.length,
    //         itemBuilder: (context, index) {
    //           return ListTile(
    //               leading: CircleAvatar(
    //                 backgroundColor: Color(0xFF764abc),
    //                 child: Text("${json[index]["nama"][0] ?? 'A'}"),
    //               ),
    //               title: Text("${json[index]["nama"] ?? 'A'}"),
    //               subtitle: Text("${json[index]["email"]}"),
    //               onTap: () {
    //                 print("nama: ${json[index]["nama"] ?? ''}");
    //                 print("email: ${json[index]["email"]}");
    //               },
    //               trailing: Row(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   IconButton(
    //                     onPressed: () {
    //                       add1.text = json[index]["nama"];
    //                       add2.text = json[index]["email"];
    //                       add3.text = json[index]["gender"];
    //                       showDialog(
    //                         context: context,
    //                         builder: (context) => AlertDialog(
    //                           title: Center(
    //                             child: Text("Update Data"),
    //                           ),
    //                           content: Form(
    //                             key: _formKey,
    //                             child: Column(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 TextFormField(
    //                                   controller: add1,
    //                                   autofocus: true,
    //                                   decoration: InputDecoration(
    //                                       hintText: "Update your name"),
    //                                   validator: (value) {
    //                                     if (value == null || value.isEmpty) {
    //                                       return 'Please enter some text';
    //                                     }
    //                                     return null;
    //                                   },
    //                                 ),
    //                                 TextFormField(
    //                                   controller: add2,
    //                                   autofocus: true,
    //                                   decoration: InputDecoration(
    //                                       hintText: "Update your email"),
    //                                   validator: (value) {
    //                                     if (value == null || value.isEmpty) {
    //                                       return 'Please enter some email';
    //                                     } else if (!EmailValidator.validate(
    //                                         value)) {
    //                                       return 'Please enter a valid email';
    //                                     }
    //                                     return null;
    //                                   },
    //                                 ),
    //                                 TextFormField(
    //                                   controller: add3,
    //                                   autofocus: true,
    //                                   decoration: InputDecoration(
    //                                       hintText: "Update your gender"),
    //                                   // validator: (value) {
    //                                   //   if (value == null || value.isEmpty) {
    //                                   //     return 'Please enter some email';
    //                                   //   } else if (!EmailValidator.validate(value)) {
    //                                   //     return 'Please enter a valid email';
    //                                   //   }
    //                                   //   return null;
    //                                   // },
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           actions: [
    //                             IconButton(
    //                               onPressed: () {
    //                                 if (_formKey.currentState!.validate()) {
    //                                   updateData(json[index]["id"], {
    //                                     "nama": add1.text,
    //                                     "email": add2.text,
    //                                     "gender": add3.text,
    //                                     "password": "",
    //                                   });
    //                                   add1.clear();
    //                                   add2.clear();
    //                                   add3.clear();
    //                                   Navigator.of(context).pop();
    //                                 }
    //                               },
    //                               icon: IconButton(
    //                                 onPressed: () {},
    //                                 icon: Icon(Icons.add),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       );
    //                     },
    //                     icon: Icon(Icons.add_circle_outline_rounded),
    //                   ),
    //                   IconButton(
    //                     onPressed: () {
    //                       deleteData(json[index]["id"]);
    //                     },
    //                     icon: Icon(Icons.remove_circle_outline),
    //                   )
    //                 ],
    //               ));
    //         },
    //       );
    //     } else if (snapshot.hasError) {
    //       return Text('${snapshot.error}');
    //     }
    //     return Center(child: const CircularProgressIndicator());
    //   },
    // );
  }
}

// Future<http.Response> getData() async {
//   final response =
//       await http.get(Uri.parse("http://192.168.0.1:8082/api/user/getAll"));
//   // await http.get(Uri.parse("https://reqres.in/api/users?per_page=15"));
//   // await Future.delayed(const Duration(seconds: 2));

//   return response;
// }

Future<http.Response> postData(Map<String, String> data) async {
  // data object example
  // data = {"name": "post method", "email": "postmethod@test.con"};
  final response =
      await http.post(Uri.parse("http://192.168.0.129:8082/api/user/insert"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
  print(response.statusCode);
  print(response.body);
  return response;
}

Future<http.Response> updateData(int id, Map<String, String> data) async {
  // data object example
  // data = {"name": "post method", "email": "postmethod@test.con"};
  final response = await http.put(
      Uri.parse("http://192.168.0.129:8082/api/user/update/${id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data));
  print(response.statusCode);
  print(response.body);
  return response;
}

Future<http.Response> deleteData(id) async {
  // data object example
  // data = {"name": "post method", "email": "postmethod@test.con"};
  final response = await http.delete(
    Uri.parse("http://192.168.0.129:8082/api/user/delete/${id}"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(response.statusCode);
  print(response.body);
  return response;
}
