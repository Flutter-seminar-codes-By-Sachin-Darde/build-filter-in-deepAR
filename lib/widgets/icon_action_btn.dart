import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  final Icon icon;
  final void Function()? onTap;
  const IconActionButton({
    Key? key,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withOpacity(0.5)),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
