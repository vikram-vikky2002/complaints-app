import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app/components/basePage.dart';
import 'package:complaint_app/components/glassTextFields.dart';
import 'package:complaint_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ComplaintRegisterPage extends StatefulWidget {
  const ComplaintRegisterPage({super.key});

  @override
  State<ComplaintRegisterPage> createState() => _ComplaintRegisterPageState();
}

class _ComplaintRegisterPageState extends State<ComplaintRegisterPage> {
  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  File? _imageFile = null;
  double uploadProgress = 0.0;
  String? imagesUrl;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FireAuth().currentUser;
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(_picker, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(_picker, ImageSource.camera);
                  // _pickImage(_picker, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
    // await _getImage(_picker);
  }

  Future<void> _getImage(_picker, source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  reset() {
    setState(() {
      _imageFile = null;
      title.clear();
      description.clear();
      location.clear();
    });
    Timer(const Duration(seconds: 2), () {
      _btnController.reset();
    });
  }

  upload() async {
    if (_imageFile == null) {
      Fluttertoast.showToast(
        msg: 'Please choose any image',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });

      return;
    }
    if (title.text == "" || description.text == "" || location.text == "") {
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });

      Fluttertoast.showToast(
        msg: 'Please fill all the details',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }
    try {
      var ID = DateFormat('ddMMyyyyhhmmss').format(DateTime.now());
      final FirebaseStorage _storage = FirebaseStorage.instance;
      final Reference storageRef =
          _storage.ref().child('complaints/${user?.email}-${title.text}.jpg');
      final UploadTask uploadTask = storageRef.putFile(_imageFile!);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      uploadTask.whenComplete(() async {
        imagesUrl = await storageRef.getDownloadURL();
        setState(() {
          uploadProgress = 0.0;
        });
      }).then((value) async {
        var data = {
          'id': ID,
          'title': title.text,
          'description': description.text,
          'date': DateTime.now(),
          'images': imagesUrl,
          'location': location.text,
          'userID': user?.email ?? "...",
          'status': false,
        };
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(ID)
            .set(data);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .update({
          'complaints': FieldValue.arrayUnion([ID])
        });

        Fluttertoast.showToast(
          msg: 'Upload Successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }).then((value) {
        _btnController.success();
        reset();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              Timer(const Duration(seconds: 2), () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
              return const Scaffold(
                backgroundColor: Color.fromARGB(255, 43, 189, 10),
                body: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Icon(
                          Icons.done_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      Text(
                        'Uploaded Sucessfully',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
        //   Timer(const Duration(seconds: 2), () {

        // });
      });

      // await FirebaseFirestore.instance.collection('complaints').doc().set(
      //   {
      //     'title': title.text,
      //     'description': description.text,
      //     'date': DateTime.now(),
      //     'images': imagesUrl,
      //     'userID': user?.uid ?? "...",
      //   },
      // ).then((value) {
      //   _btnController.success();
      //   Timer(const Duration(seconds: 2), () {
      //     _btnController.reset();
      //   });
      // });
    } on FirebaseException catch (error) {
      _btnController.error();
      Fluttertoast.showToast(
        msg: 'Error : $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // user == null
    //     ? Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const LoginPage(),
    //         ),
    //       )
    //     : null;
    return BackgroundPage(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 60, bottom: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'New Complaint',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'Fonarto',
                    fontSize: MediaQuery.of(context).size.width * 0.068,
                  ),
                ),
              ),
              GlassTextField(
                labelText: "Title",
                validator: ValidationBuilder()
                    .required("This field is required")
                    .build(),
                cont: title,
              ),
              const SizedBox(height: 16),
              GlassDescriptionField(
                labelText: "Description",
                validator: ValidationBuilder()
                    .required("This field is required")
                    .build(),
                cont: description,
              ),
              const SizedBox(height: 16),
              GlassTextField(
                labelText: "Location",
                validator: ValidationBuilder()
                    .required("This field is required")
                    .build(),
                cont: location,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _imageFile == null
                        ? SizedBox(
                            height: 100,
                            child: Image.asset("assets/icons/placeHolder.jpg"),
                          )
                        : SizedBox(
                            height: 100,
                            child: Image.file(_imageFile!),
                          ),
                    ElevatedButton(
                      onPressed: () {
                        // setState(() {});
                        pickImage();
                      },
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              if (uploadProgress > 0.0)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Uploading... ${(uploadProgress * 100).toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'Fonarto',
                        // fontSize: MediaQuery.of(context).size.width * 0.068,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        value: uploadProgress,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 25),
              RoundedLoadingButton(
                onPressed: () {
                  upload();

                },
                controller: _btnController,
                child: const Text('Submit',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Fonarto',
                      fontSize: 20,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
