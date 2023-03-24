import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldBuilder extends StatelessWidget {
  
  final String title;
  final String? hintText;
  final String? errorText;
  final String? labelText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final List<TextInputFormatter> formatter;
  final AutovalidateMode? autovalidateMode;
  final FormFieldValidator<String>? validator;

  const TextFormFieldBuilder({
    Key? key,
    this.maxLines,
    this.errorText,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.title = '',
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autovalidateMode,
    this.formatter = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _getFormField
      ],
    ); 
  }

  Widget get _getFormField {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: formatter,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
    );
  }
}