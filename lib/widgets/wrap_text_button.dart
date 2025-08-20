import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/utils/colors_utils.dart';

class WrapTextButton extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double? radius;
  final double? height;
  final double? minWidth;
  final double? maxWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const WrapTextButton(this.title, {
    super.key,
    this.textStyle,
    this.backgroundColor = ColorsUtils.colorPrimary,
    this.textColor = Colors.white,
    this.borderColor,
    this.radius,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.padding,
    this.margin,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 44,
      padding: margin ?? EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0,
        maxWidth: maxWidth ?? double.infinity
      ),
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) => backgroundColor),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12),
            side: borderColor != null
              ? BorderSide(width: 1, color: borderColor!)
              : BorderSide.none
          )),
          padding: WidgetStateProperty.resolveWith<EdgeInsets>((Set<WidgetState> states) => padding ?? const EdgeInsets.symmetric(vertical: 12)),
          elevation: WidgetStateProperty.resolveWith<double>((Set<WidgetState> states) => 0)),
        child: Text(title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textStyle ?? TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor
          )
        ),
      ),
    );
  }
}
