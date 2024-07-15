import 'package:flutter/material.dart';

class TextFormFeildWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? prefix;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;

  const TextFormFeildWidget({
    super.key,
    required this.obscureText,
    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    this.validator,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        prefixIcon: prefixIcon,
        prefix: prefix,
        hintText: hintText,
        labelStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 100, 100, 100)
            : Colors.white,
        errorStyle: const TextStyle(color: Colors.black),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 100, 100, 100)
                : Colors.white,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 100, 100, 100)
                : Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 100, 100, 100)
                : Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 100, 100, 100)
                : Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 100, 100, 100)
                : Colors.white,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}
