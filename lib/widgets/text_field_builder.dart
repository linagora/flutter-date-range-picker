import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_range_picker/utils/colors_utils.dart';

class TextFieldBuilder extends StatelessWidget {
  final ValueChanged<String>? onTextChange;
  final ValueChanged<String>? onTextSubmitted;
  final TextInputAction? textInputAction;
  final InputDecoration? inputDecoration;
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final TextStyle? textStyle;
  final Color cursorColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final double borderRadius;
  final double? maxWidth;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldBuilder({
    Key? key,
    this.onTextChange,
    this.onTextSubmitted,
    this.textStyle,
    this.textInputAction,
    this.inputDecoration,
    this.textController,
    this.keyboardType,
    this.cursorColor = ColorsUtils.colorPrimary,
    this.autoFocus = false,
    this.focusNode,
    this.borderRadius = 12.0,
    this.hintText,
    this.maxWidth,
    this.inputFormatters
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onTextChange,
      cursorColor: cursorColor,
      controller: textController,
      textInputAction: textInputAction,
      decoration: inputDecoration ?? InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1,
            color: ColorsUtils.colorInputBorder)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1,
            color: ColorsUtils.colorInputBorderFocus)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1,
            color: ColorsUtils.colorInputBorderError)),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1,
            color: ColorsUtils.colorInputBorderError)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500),
        hintText: hintText,
        isDense: true,
        hintStyle: const TextStyle(
          color: ColorsUtils.colorHintInput,
          fontSize: 16,
          fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        errorStyle: const TextStyle(
          color: ColorsUtils.colorErrorInput,
          fontSize: 16,
          fontWeight: FontWeight.normal),
        filled: true,
        constraints: BoxConstraints(maxWidth: maxWidth ?? 130),
        fillColor: ColorsUtils.colorDefault
      ),
      keyboardAppearance: Brightness.light,
      style: textStyle ?? const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16.0
      ),
      keyboardType: keyboardType,
      onSubmitted: onTextSubmitted,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
    );
  }
}
