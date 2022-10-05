import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_picker/utils/colors_utils.dart';

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
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldBuilder(
      {Key? key,
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
      this.borderRadius = 10.0,
      this.hintText,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onTextChange,
      cursorColor: cursorColor,
      controller: textController,
      textInputAction: textInputAction,
      decoration: inputDecoration ??
          InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                      width: 1, color: ColorsUtils.colorInputBorder)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                      width: 1, color: ColorsUtils.colorInputBorderFocus)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                      width: 1, color: ColorsUtils.colorInputBorderError)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                      width: 1, color: ColorsUtils.colorInputBorderError)),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
              hintText: hintText,
              isDense: true,
              hintStyle: const TextStyle(
                  color: ColorsUtils.colorHintInput,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              errorStyle: const TextStyle(
                  color: ColorsUtils.colorErrorInput,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
              filled: true,
              constraints: const BoxConstraints(maxWidth: 120),
              fillColor: ColorsUtils.colorDefault),
      keyboardAppearance: Brightness.light,
      style: textStyle ??
          const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 12.0),
      keyboardType: keyboardType,
      onSubmitted: onTextSubmitted,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
    );
  }
}
