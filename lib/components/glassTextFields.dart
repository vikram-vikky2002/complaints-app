import 'package:flutter/material.dart';

class GlassTextField extends StatelessWidget {
  final TextEditingController cont;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final TextStyle? hintStyle;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final ValueNotifier<String>? valueNotifier;
  final Iterable<String>? autofillHints;

  const GlassTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.validator,
    this.valueNotifier,
    this.hintStyle,
    this.autofillHints,
    this.enabled = true,
    required this.cont,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: cont,
      keyboardType: TextInputType.phone,
      enabled: enabled,
      autofillHints: autofillHints,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: validator,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: hintStyle,
        helperText: helperText,
        border: const OutlineInputBorder(),
        floatingLabelStyle:
            const TextStyle(color: Color.fromARGB(255, 2, 2, 2), fontSize: 22),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: const Color.fromARGB(255, 1, 8, 7).withOpacity(1),
              width: 2.0),
          borderRadius: BorderRadius.circular(25),
        ),
        fillColor: const Color.fromARGB(255, 190, 237, 232).withOpacity(0.4),
        filled: true,
      ),
    );
  }
}
