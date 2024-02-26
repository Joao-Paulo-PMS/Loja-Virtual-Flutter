import 'package:brasil_fields/src/formatters/real_input_formatter.dart';
import'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;
  final Function(String) validator;
  final dynamic Function(String) onSaved;
  final TextInputType keyboardType;

  InputCustomizado({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text,
    required this.inputFormatters,
    required this.maxLines,
    required this.validator,
   required this.onSaved,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.type,
      inputFormatters: this.inputFormatters,
      validator: (validator) {
        if (validator == null || validator.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      maxLines: this.maxLines,
      onSaved: (val) {
        print('saved');
      },
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6)
          )
      ),
    );
  }
}
