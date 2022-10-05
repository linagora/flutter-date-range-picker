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

  const WrapTextButton(this.title,
      {Key? key,
      this.textStyle,
      this.backgroundColor = ColorsUtils.colorDefault,
      this.textColor = Colors.black,
      this.borderColor,
      this.radius,
      this.height,
      this.minWidth,
      this.maxWidth,
      this.padding,
      this.margin,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 32,
      padding: margin ?? EdgeInsets.zero,
      constraints: BoxConstraints(
          minWidth: minWidth ?? 0, maxWidth: maxWidth ?? double.infinity),
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) => backgroundColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 8),
                side: borderColor != null
                    ? BorderSide(width: 1, color: borderColor!)
                    : BorderSide.none)),
            padding: MaterialStateProperty.resolveWith<EdgeInsets>(
                (Set<MaterialState> states) =>
                    padding ??
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
            elevation: MaterialStateProperty.resolveWith<double>(
                (Set<MaterialState> states) => 0)),
        child: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textStyle ??
                TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: textColor)),
      ),
    );
  }
}
