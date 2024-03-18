import 'package:complaint_app/firebase_options.dart';
import 'package:complaint_app/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // FIREBASE INIT
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const LoginPage(),
      home: const HomePage(),
      // home: const ProfilePage(),
      // home: Scaffold(
      //   backgroundColor: Color.fromARGB(255, 43, 189, 10),
      //   body: SizedBox(
      //     width: double.infinity,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         SizedBox(
      //           height: 100,
      //           width: 100,
      //           child: Icon(
      //             Icons.done_outlined,
      //             color: Colors.white,
      //             size: 40,
      //           ),
      //         ),
      //         Text(
      //           'Uploaded Sucessfully',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
