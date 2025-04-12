import 'package:flutter/material.dart';

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
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.titleMedium,
      maxLines: null,
      textAlign: textAlign,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}