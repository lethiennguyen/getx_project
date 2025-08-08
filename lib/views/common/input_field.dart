import 'package:flutter/material.dart';
import 'package:getx_statemanagement/views/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final bool isPassword;

  const ModernInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
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
        // Label
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
          focusNode: widget.focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          cursorColor: kBrandOrange,
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
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
