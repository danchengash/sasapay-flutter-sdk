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
    this.fontSize = 20,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [
      Color(0xff003359),
      Color(0xff005492),
      Color.fromARGB(255, 13, 103, 167),
    ]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(18);
    return Material(
      borderRadius: borderRadius,
      elevation: 7,
      child: InkWell(
        onTap: () {
          onPressed!();
        },
        child: Container(
          alignment: Alignment.center,
          width: width,
          padding: const EdgeInsets.all(5),
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                label ?? '',
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
