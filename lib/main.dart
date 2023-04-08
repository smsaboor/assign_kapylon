import 'package:assign_kapylon/model/user.dart';
import 'package:assign_kapylon/utils/firebase_helper.dart';
import 'package:assign_kapylon/utils/sqlite_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:assign_kapylon/page/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assign_kapylon/widget/avatar_widget.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Task Kapylon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataHelper databaseHelper = DataHelper();
  var data;
  var onlineUsers;
  bool loading = true;
  bool isOffline = true;
  late var subscription;

  Future getUserOffline() async {
    setState(() {
      loading = true;
    });
    data = await databaseHelper.getUserList();
    setState(() {
      loading = false;
    });
    if (data.length != 0) {
      if (isOffline) {
      } else {
        for (int i = 0; i < data.length; i++) {
          User user = User(
              userId: data[i]['userId'],
              imagePath: data[i]['imagePath'],
              name: data[i]['name'],
              address: data[i]['address'],
              dob: data[i]['dob']);
          await FirebaseHelper.addUserToFirebase(user.toJson());
          await databaseHelper.deleteUser(data[i]['userId']);
        }
        data = await databaseHelper.getUserList();
      }
    }
    setState(() {});
  }

  void _addUser() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ProfilePage())).then((value) => getUserOffline());
  }

  // checkConnectivity(context) async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     snackBar(context: context, data: 'Mobile', color: Colors.green);
  //     // I am connected to a mobile network.
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     snackBar(context: context, data: 'Wifi', color: Colors.green);
  //     // I am connected to a wifi network.
  //   } else if (connectivityResult == ConnectivityResult.none) {
  //     snackBar(context: context, data: 'You are offline!', color: Colors.red);
  //   } else {
  //     snackBar(context: context, data: 'Unknown error!', color: Colors.red);
  //   }
  // }
  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      isOffline = true;
      print('---------------result::::$result');
      if (result == ConnectivityResult.mobile) {
        isOffline = false;
        getUserOffline();
        snackBar(context: context, data: 'Mobile', color: Colors.green);
        // I am connected to a mobile network.
      } else if (result == ConnectivityResult.wifi) {
        isOffline = false;
        getUserOffline();
        snackBar(context: context, data: 'Wifi', color: Colors.green);
        // I am connected to a wifi network.
      } else if (result == ConnectivityResult.none) {
        isOffline = true;
        snackBar(context: context, data: 'You are offline!', color: Colors.red);
      } else {
        isOffline = true;
        snackBar(context: context, data: 'Unknown error!', color: Colors.red);
      }
    });
    getUserOffline();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                getUserOffline();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text(
                'Online Users',
                style: TextStyle(color: Colors.green, fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("Loading...");
                          }
                          print('snapshot --${snapshot.data!.docs.length}');
                          var docs = snapshot.data!.docs;
                          return snapshot.data!.docs.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 128.0),
                                  child: Text('No Online Users Found!'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            docs[index]["imagePath"] == 'null'
                                                ? AvatarWidget(
                                                    imagePath: 'assets/img.png',
                                                    isFile: false,
                                                    width: 70.0,
                                                    height: 70.0,
                                                    isEdit: false,
                                                    onClicked: () async {},
                                                  )
                                                : AvatarWidget(
                                                    imagePath: File(docs[index]
                                                        ["imagePath"]),
                                                    isFile: true,
                                                    width: 70.0,
                                                    height: 70.0,
                                                    isEdit: false,
                                                    onClicked: () async {},
                                                  ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${docs[index]["name"]}.",
                                                ),
                                                Text(
                                                  "${docs[index]["dob"]}.",
                                                ),
                                                Text(
                                                  "${docs[index]["address"]}.",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ));
                                  });
                        }),
                  ),
            const Center(
              child: Text(
                'Offline Users',
                style: TextStyle(color: Colors.red, fontSize: 22),
              ),
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  data[index]["imagePath"] == 'null'
                                      ? AvatarWidget(
                                          imagePath: 'assets/img.png',
                                          isFile: false,
                                          width: 70.0,
                                          height: 70.0,
                                          isEdit: false,
                                          onClicked: () async {},
                                        )
                                      : AvatarWidget(
                                          imagePath:
                                              File(data[index]["imagePath"]),
                                          isFile: true,
                                          width: 70.0,
                                          height: 70.0,
                                          isEdit: false,
                                          onClicked: () async {},
                                        ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data[index]["name"]}.",
                                      ),
                                      Text(
                                        "${data[index]["dob"]}.",
                                      ),
                                      Text(
                                        "${data[index]["address"]}.",
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  snackBar(
      {required BuildContext context,
      required String data,
      required Color color}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Padding(
              padding: const EdgeInsets.only(left: 10.0), child: Text(data)),
          backgroundColor: color,
          behavior: SnackBarBehavior.fixed));
  }
}
