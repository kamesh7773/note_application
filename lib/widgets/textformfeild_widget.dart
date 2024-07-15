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
        suffixIcon: suffixIcon,
        filled: true,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}
