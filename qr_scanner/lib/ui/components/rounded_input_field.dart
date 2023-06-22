import 'package:flutter/material.dart';
import 'package:qr_scanner/ui/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChange;

  const RoundedInputField({
    super.key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
