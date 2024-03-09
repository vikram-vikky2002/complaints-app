import 'dart:async';

import 'package:complaint_app/components/basePage.dart';
import 'package:complaint_app/components/glassTextFields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_validator/form_validator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ComplaintRegisterPage extends StatefulWidget {
  const ComplaintRegisterPage({super.key});

  @override
  State<ComplaintRegisterPage> createState() => _ComplaintRegisterPageState();
}

class _ComplaintRegisterPageState extends State<ComplaintRegisterPage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 100, bottom: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GlassTextField(
                labelText: "Title",
                validator: ValidationBuilder()
                    .required("This field is required")
                    .build(),
                cont: title,
              ),
              const SizedBox(height: 16),
              GlassTextField(
                labelText: "Description",
                validator: ValidationBuilder()
                    .required("This field is required")
                    .build(),
                cont: description,
              ),
              const SizedBox(height: 16),
              RoundedLoadingButton(
                onPressed: () {
                  Timer(const Duration(seconds: 2), () {
                    _btnController.success();
                  });
                  Timer(const Duration(seconds: 4), () {
                    _btnController.reset();
                  });
                },
                controller: _btnController,
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
