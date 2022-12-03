import 'package:flutter/material.dart';

class CustomElevatedButtonWithChild extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget? child;
  final String? label;
  final double? fontSize;

  const CustomElevatedButtonWithChild({
    Key? key,
    required this.onPressed,
    this.child,
    this.label,
    this.borderRadius,
    this.fontSize,
    this.width,
    this.height = 44.0,
    this.gradient =
        const LinearGradient(colors: [Color(0xff0D71E1), Color(0xff12E63D)]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(18);
    return InkWell(
      onTap: () {
        onPressed!();
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        padding: const EdgeInsets.all(5),
        height: height,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0, // soften the shadow
              spreadRadius: -0.9, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                5.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          gradient: gradient,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              label ?? '',
              style:
                  TextStyle(color: Colors.white, fontSize: fontSize),
            ),
            child ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
