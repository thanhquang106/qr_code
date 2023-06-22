
import 'package:flutter/material.dart';
import 'package:qr_scanner/ui/components/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    super.key,
    required this.onChanged,
  });

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        obscureText: _isObscure,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.white,
          ),
          hintText: "password",
          hintStyle: const TextStyle(color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(
                () {
                  _isObscure = !_isObscure;
                },
              );
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
