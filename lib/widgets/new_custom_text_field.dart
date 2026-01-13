import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCustomTextField extends StatelessWidget {
  const NewCustomTextField({
    super.key,
    required this.name,
    required this.hint,
    required this.icon,
    this.onChanged,

    this.isPasswrod = false,
    this.keyboardType = TextInputType.text,
  });
  final String name;
  final String hint;
  final IconData icon;
  final bool isPasswrod;
  final Function(String)? onChanged;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            name,
            style: GoogleFonts.rubik(
              textStyle: const TextStyle(fontSize: 16, fontWeight: .w500),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            keyboardType: keyboardType,
            onChanged: onChanged,
            obscureText: isPasswrod,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: Icon(icon),
              border: const UnderlineInputBorder(),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffFF8383)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffBDBDBD)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
