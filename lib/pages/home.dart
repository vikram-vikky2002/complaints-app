import 'dart:async';

import 'package:complaint_app/components/basePage.dart';
import 'package:complaint_app/pages/complaint.dart';
import 'package:complaint_app/pages/loginPage.dart';
import 'package:complaint_app/services/auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _timeString;
  User? user;


  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  late StreamSubscription internet;
  var isDeviceConnected = false, isAlertSet = false;

  showDialogBox() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Check your internet connection'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'cancel');
                setState(() {
                  isAlertSet = false;
                });
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox();
                  setState(() {
                    isAlertSet = true;
                  });
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  getConnectivity() =>
      internet = Connectivity().onConnectivityChanged.listen((event) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showDialogBox();
          setState(() {
            isAlertSet = true;
          });
        }
      });

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    user = FireAuth().currentUser;
    super.initState();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy\nhh:mm:ss a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _timeString ?? "",
                      style: const TextStyle(
                        fontFamily: 'Fonarto',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                      tag: "Logo",
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Image.asset('assets/icons/PoliceLogo.png'),
                      ),
                    ),
                    Text(
                      'Police Department\nKaraikal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'Fonarto',
                        fontSize: MediaQuery.of(context).size.width * 0.068,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      // vertical: 50,
                    ),
                    child: InkWell(
                      onTap: () {
                        user = FireAuth().currentUser;
                        // setState(() {});
                        if (user != null) {
                          if (kDebugMode) {
                            print('user');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ComplaintRegisterPage(),
                            ),
                          );
                        } else {
                          if (kDebugMode) {
                            print('no user');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.11,
                              child: Image.asset('assets/icons/complaint.png'),
                            ),
                            const Text(
                              'Register New \nComplaint',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: 'Fonarto',
                                // fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        ),
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child:
                                      Image.asset('assets/icons/profile.png'),
                                ),
                              ),
                              const Text(
                                'Profile',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: 'Fonarto',
                                  fontWeight: FontWeight.bold,
                                  // fontSize: 25,
                                ),
                              ),
                              const SizedBox(height: 10)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: Image.asset('assets/icons/info.png'),
                              ),
                            ),
                            const Text(
                              'About Us',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: 'Fonarto',
                                fontWeight: FontWeight.bold,
                                // fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              const SizedBox(height: 100),
              const Padding(
                padding: EdgeInsets.all(13),
                child: Text(
                  'Made by AppAlchemy 📱',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
