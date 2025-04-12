import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle? style;

  const CustomTextWidget(
    this.text, {
    super.key,
    this.textAlign = TextAlign.center,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: style ?? Theme.of(context).textTheme.titleMedium,
      maxLines: 3,
      textAlign: textAlign,
      softWrap: true,
      overflow: TextOverflow.visible,
      minFontSize: 10,
      stepGranularity: 1,
      maxFontSize: style?.fontSize ?? 30,
    );
  }
}
