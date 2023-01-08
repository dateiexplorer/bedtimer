import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final Widget child;

  const CustomListItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.verified),
        const SizedBox(width: 8.0),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
