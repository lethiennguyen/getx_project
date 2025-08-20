import 'package:flutter/material.dart';
import 'package:getx_statemanagement/views/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../enums/discount.dart';

class ModernInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  const ModernInputField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: widget.readOnly,
          focusNode: widget.focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          cursorColor: kBrandOrange,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kBrandOrange, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xffEBECED), width: 2),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kBrandOrange2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class ModernDropdownField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;

  const ModernDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(itemLabel(item)),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
