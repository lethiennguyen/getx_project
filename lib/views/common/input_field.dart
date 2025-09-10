import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getx_statemanagement/views/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../base/asset/base_asset.dart';
import '../../enums/discount.dart';

class ModernInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final isboderRadius;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  const ModernInputField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.isboderRadius = true,
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
              borderRadius:
                  widget.isboderRadius
                      ? BorderRadius.circular(12)
                      : BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
              borderSide: BorderSide(color: kBrandOrange, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  widget.isboderRadius
                      ? BorderRadius.circular(12)
                      : BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
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
  final FocusNode? focusNode;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;

  const ModernDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.focusNode,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const borderRadius = BorderRadius.only(
      bottomRight: Radius.circular(12),
      topRight: Radius.circular(12),
    );

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
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
            border: const OutlineInputBorder(borderRadius: borderRadius),
            enabledBorder: const OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: Color(0xffEBECED), width: 2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: kBrandOrange, width: 2),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: kBrandOrange2, width: 1),
            ),
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

class AppInputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final String? errorText;
  final VoidCallback? onChanged;

  const AppInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.validator,
    this.isPassword = false,
    this.errorText,
    this.onChanged,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: const Color(0xff242E37),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: widget.isPassword ? !_isPasswordVisible : false,
          onChanged: (val) {
            widget.onChanged?.call();
          },
          cursorColor: const Color(0xffF24E1E),
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(16),
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            suffixIcon: _buildSuffixIcon(),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffF24E1E)),
              borderRadius: BorderRadius.circular(6),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffF24E1E)),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 16),
          height: 16,
          alignment: Alignment.centerRight,
          child: Text(
            widget.errorText ?? '',
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: const Color(0xffFF0000),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return GestureDetector(
        onTap: () {
          _isPasswordVisible = !_isPasswordVisible;
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            _isPasswordVisible ? IconsAssets.eye_slash : IconsAssets.eye,
            width: 12,
            height: 12,
          ),
        ),
      );
    } else if (widget.controller.text.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          widget.controller.clear();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(IconsAssets.clear, width: 10, height: 10),
        ),
      );
    }
    return null;
  }
}
