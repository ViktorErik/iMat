import 'package:flutter/material.dart';

class ClickableText extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle? defaultStyle;
  final TextStyle? hoverStyle;

  const ClickableText({
    super.key,
    required this.text,
    this.onTap,
    this.defaultStyle,
    this.hoverStyle,
  });

  @override
  _ClickableTextState createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = widget.defaultStyle ??
        const TextStyle(color: Colors.black);
    final hoverStyle = widget.hoverStyle ??
        const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: _isHovering ? hoverStyle : defaultStyle,
        ),
      ),
    );
  }
}