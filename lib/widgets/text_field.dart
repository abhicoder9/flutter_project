import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController texteditingController;
  final String hintText;
  final TextInputType textInputType;
  final bool isPass;

  const MyTextField(
      {super.key,
      required this.hintText,
      this.isPass = false,
      required this.textInputType,
      required this.texteditingController});

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: texteditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
