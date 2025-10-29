import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final int? maxLines;
  final IconData? prefixIcon;
  final VoidCallback? onPrefixIconPressed;
  final VoidCallback? onSuffixIconPressed;
  final bool showPasswordToggle;
  final bool isPasswordVisible;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.maxLines = 1,
    this.prefixIcon,
    this.onPrefixIconPressed,
    this.onSuffixIconPressed,
    this.showPasswordToggle = false,
    this.isPasswordVisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText && !isPasswordVisible,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? IconButton(
                    icon: Icon(prefixIcon),
                    onPressed: onPrefixIconPressed,
                  )
                : null,
            suffixIcon: _buildSuffixIcon(),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (showPasswordToggle) {
      return IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey[600],
        ),
        onPressed: onSuffixIconPressed,
      );
    }
    
    if (suffixIcon != null && onSuffixIconPressed != null) {
      return IconButton(
        icon: suffixIcon!,
        onPressed: onSuffixIconPressed,
      );
    }
    
    return suffixIcon;
  }
}