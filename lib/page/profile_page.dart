import 'dart:io';
import 'package:assign_kapylon/model/user.dart';
import 'package:assign_kapylon/widget/date.dart';
import 'package:assign_kapylon/utils/sqlite_helper.dart';
import 'package:assign_kapylon/utils/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:assign_kapylon/widget/avatar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ImageSourceType { gallery, camera }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  DataHelper databaseHelper = DataHelper();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();
  var avatarImageFile;
  XFile? pickedFile;
  bool saving = false;
  bool isConnected = false;

  checkConnectivity(context) async {
    isConnected = false;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnected = true;
      snackBar(context: context, data: 'Mobile', color: Colors.green);
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
      snackBar(context: context, data: 'Wifi', color: Colors.green);
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.none) {
      isConnected = false;
      snackBar(context: context, data: 'You are offline!', color: Colors.red);
    } else {
      isConnected = false;
      snackBar(context: context, data: 'Unknown error!', color: Colors.red);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 50,
            ),
            avatarImageFile == null
                ? AvatarWidget(
                    imagePath: 'assets/img.png',
                    isFile: false,
                    width: 128.0,
                    height: 128.0,
                    isEdit: true,
                    onClicked: () async {
                      showAlertDialog(context);
                    },
                  )
                : AvatarWidget(
                    imagePath: avatarImageFile,
                    isFile: true,
                    width: 128.0,
                    height: 128.0,
                    isEdit: true,
                    onClicked: () async {
                      showAlertDialog(context);
                    },
                  ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: _controllerName,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter User Name';
                    }
                    if (value!.length < 4) {
                      return 'length must 4 digit';
                      return 'Mobile number must be 10 digit';
                    }
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIconColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 40, minWidth: 40),
                    hintText: 'Enter User Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: _controllerAddress,
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Address';
                    }
                    if (value!.length < 5) {
                      return 'limit 5 character';
                      return 'Mobile number must be 10 digit';
                    }
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIconColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 40, minWidth: 40),
                    hintText: 'Enter Address',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 0),
              child: SizedBox(
                height: 45,
                child: CustomDate(
                  controller: _controllerDob,
                  initialDate: DateTime(2010),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2022),
                  validator: (value) {
                    if (_controllerDob.text.isEmpty) {
                      return 'Enter date of birth';
                    }
                  },
                  labelText: 'Select date of birth',
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
              width: MediaQuery.of(context).size.width * .9,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, right: 28, top: 8, bottom: 8),
                child: InkWell(
                  onTap: () {
                    addUser(context);
                  },
                  // style: ButtonStyle(side: ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: saving
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addUser(BuildContext context) async {
    if (_key.currentState!.validate()) {
      setState(() {
        saving = true;
      });
      User user = User(
          imagePath: avatarImageFile == null ? 'null' : avatarImageFile.path,
          name: _controllerName.text,
          address: _controllerAddress.text,
          dob: _controllerDob.text);
      if (avatarImageFile == null) {
        snackBar(
            context: context, data: 'select your image', color: Colors.black);
      } else {
        await checkConnectivity(context);
        if (isConnected) {
          FirebaseHelper.addUserToFirebase(user.toJson());
        } else {
          await databaseHelper.insertUser(user);
        }
        setState(() {
          saving = false;
        });
        Navigator.pop(context);
      }
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              _handleImage(context, ImageSourceType.gallery);
            },
            child: const ListTile(
                title: Text("From Gallery"),
                leading: Icon(
                  Icons.image,
                  color: Colors.deepPurple,
                )),
          ),
          Container(
            width: 200,
            height: 1,
            color: Colors.black12,
          ),
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              _handleImage(context, ImageSourceType.camera);
            },
            child: const ListTile(
                title: Text(
                  "From Camera",
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(
                  Icons.camera,
                  color: Colors.red,
                )),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _handleImage(BuildContext context, var type) async {
    var imagePicker = ImagePicker();
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    PickedFile? pickedFile =
        await imagePicker.getImage(source: source).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
      print('image${image}');
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
      });
    }
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
