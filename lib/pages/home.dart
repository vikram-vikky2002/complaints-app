import 'package:complaint_app/components/basePage.dart';
import 'package:complaint_app/components/glassTextFields.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController phone = TextEditingController();
  String errorText = "";
  bool valid = false;

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
        child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Signin',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Enter Your Phone Number',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '  +91',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: GlassTextField(
                    validator: ValidationBuilder()
                        .required("This field is required")
                        .phone("Enter a valid phone number")
                        .minLength(10)
                        .build(),
                    cont: phone,
                    hintText: 'Enter your Phone number',
                    hintStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              valid ? "" : errorText,
              // errorText ?? "",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Get OTP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
